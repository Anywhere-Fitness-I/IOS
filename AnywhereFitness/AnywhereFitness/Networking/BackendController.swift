//
//  BackendController.swift
//  AnywhereFitness
//
//  Created by Bhawnish Kumar on 5/22/20.
//  Copyright © 2020 Bhawnish Kumar. All rights reserved.
//

import Foundation
import CoreData

class BackendController {
    
    enum NetworkError: Error {
        case failedSignUp, failedSignIn, noData, badData
        case notSignedIn, failedFetch, badURL
    }
    
    private enum LoginStatus {
        case notLoggedIn
        // if there are logged in or not, if they are then we want to access the bearer token for signing in
        case loggedIn(Token)
        
        static var isLoggedIn: Self {
            if let bearer = BackendController.token {
                return loggedIn(bearer)
            } else {
                return notLoggedIn
            }
        }
    }
        
    static let shared = BackendController()
   typealias CompletionHandler = (Result<Bool, NetworkError>) -> Void
    private var baseURL: URL = URL(string: "https://anywhere-fit.herokuapp.com/")!
    
    private var encoder = JSONEncoder()
    private var decoder = JSONDecoder()
    
    static var token: Token?
    var dataLoader: DataLoader?
    
    let bgContext = CoreDataStack.shared.container.newBackgroundContext()
    let operationQueue = OperationQueue()
    
    init(dataLoader: DataLoader = URLSession.shared) {
        self.dataLoader = dataLoader
        populateCache()
    }
    
    var userCourse: [Course] = []
    
    var instructorId: Int64? {
        didSet {
            loadClass()
        }
    }
    var cache = Cache<Int64, Course>()
    
    var isSignedIn: Bool {
        // swiftlint: disable all
        return BackendController.token != nil
        // swiftlint: enable all
    }
    
    func signUp(firstName: String,
                lastName: String,
                email: String,
                password: String,
                role: String,
                completion: @escaping (Bool, URLResponse?, Error?) -> Void) {
        
        let newUser = UserRepresentation(firstName: firstName, lastName: lastName, email: email, password: password, role: role)
        
        let requestURL = baseURL.appendingPathComponent(EndPoints.register.rawValue)
        var request = URLRequest(url: requestURL)
        request.httpMethod = Method.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            
            // Try to encode the newly created user into the request body.
            let jsonData = try encoder.encode(newUser)
            request.httpBody = jsonData
        } catch {
            NSLog("Error encoding newly created user: \(error)")
            return
        }
        
        dataLoader?.loadData(from: request) { _, response, error in
            
            if let error = error {
                NSLog("Error sending sign up parameters to server : \(error)")
                completion(false, nil, error)
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode == 500 {
                NSLog("User already exists in the database. Therefore user data was sent successfully to database.")
                completion(false, response, nil)
                return
            }
            
            //            guard let data = data else { return }
            
            //            do {
            //                _ = try self.decoder.decode(UserRepresentation.self, from: data)
            //            } catch {
            //                NSLog("Error decoding data: \(error)")
            //                completion(false, nil, error)
            //            }
            
            // We'll only get down here if everything went right
            completion(true, nil, nil)
        }
    }
    
    
    func signIn(email: String, password: String, completion: @escaping (Bool) -> Void) {
        
        // Build EndPoint URL and create request with URL
        let requestURL = baseURL.appendingPathComponent(EndPoints.login.rawValue)
        var request = URLRequest(url: requestURL)
        request.httpMethod = Method.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            // Try to create a JSON from the passaed in parameters, and embedding it into requestHTTPBody.
            let jsonData = try jsonFromDict(email: email, password: password)
            request.httpBody = jsonData
        } catch {
            NSLog("Error creating json from passed in username and password: \(error)")
            return
        }
        dataLoader?.loadData(from: request, completion: { data, _, error in
            if let error = error {
                NSLog("Error logging in. \(error)")
                completion(self.isSignedIn)
                return
            }
            
            guard let data = data else {
                NSLog("Invalid data received while loggin in.")
                completion(self.isSignedIn)
                return
            }
            
            self.bgContext.perform {
                do {
                    let tokenResult = try self.decoder.decode(Token.self, from: data)
                    BackendController.token = tokenResult
                    self.storeUser(email: email) { _ in
                        completion(self.isSignedIn)
                    }
                } catch {
                    NSLog("Error decoding received token. \(error)")
                    completion(self.isSignedIn)
                }
            }
            
        })
        
    }
    
    private func storeUser(email: String, completion: @escaping (Error?) -> Void) {
        let requestURL = baseURL.appendingPathComponent(EndPoints.login.rawValue)
        var request = URLRequest(url: requestURL)
        request.httpMethod = Method.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let data = try jsonFromUsername(email: email)
            request.httpBody = data
            
        } catch {
            NSLog("Error creating json for finding user by username: \(error)")
            return
        }
        
        dataLoader?.loadData(from: request) { data, _, error in
            if let error = error {
                NSLog("Error couldn't fetch existing user: \(error)")
                completion(error)
                return
            }
            
            
            guard let data = data else {
                let error = AnywayError.badData("Invalid data returned from searching for a specific user.")
                completion(error)
                return
            }
            
            do {
                if let decodedUser = try self.decoder.decode([UserRepresentation].self, from: data).first {
                    self.instructorId = decodedUser.id
                    completion(nil)
                }
            } catch {
                NSLog("Couldn't decode user fetched by username: \(error)")
                completion(error)
            }
        }
    }
    
    private func jsonFromDict(email: String, password: String) throws -> Data? {
        var dic: [String: String] = [:]
        dic["email"] = email
        dic["password"] = password
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
            return jsonData
        } catch {
            NSLog("Error Creating JSON from Dictionary. \(error)")
            throw error
        }
    }
    
    private func jsonFromUsername(email: String) throws -> Data? {
        var dic: [String: String] = [:]
        dic["email"] = email
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
            return jsonData
        } catch {
            NSLog("Error Creating JSON From username dictionary. \(error)")
            throw error
        }
        
    }
    //name
    //type
    //date
    //startTime
    //duration
    //description
    //intensityLevel
    //location
    //maxClassSize
    

    func createClass(name: String,
                     type: String,
                     date: String,
                     startTime: String,
                     duration: String,
                     description: String,
                     intensityLevel: String,
                     location: String,
                     maxClassSize: Int64,
                     completion: @escaping (Error?) -> Void) {
        
        guard let token = BackendController.token else {
            completion(AnywayError.noAuth("No userID stored in the controller. Can't create new class."))
            return
        }
        
        let requestURL = baseURL.appendingPathComponent(EndPoints.instructorClass.rawValue)
        var request = URLRequest(url: requestURL)
        request.httpMethod = Method.post.rawValue
        request.setValue(token.token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let dict: [String: Any] = ["name": name,
                                       "type": type,
                                       "date": date,
                                       "startTime": startTime,
                                       "duration": duration,
                                       "overview": description,
                                       "intensityLevel": intensityLevel,
                                       "location": location,
                                       "maxClassSize": maxClassSize
            ]
            request.httpBody = try jsonFromDicct(dict: dict)
        } catch {
            NSLog("Error turning dictionary to json: \(error)")
            completion(error)
        }
        
        dataLoader?.loadData(from: request, completion: { data, _, error in
            if let error = error {
                NSLog("Error posting new course to database : \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                completion(AnywayError.badData("Server send bad data when creating new course."))
                return
            }
            
            self.bgContext.perform {
                do {
                    let course = try self.decoder.decode(ClassRepresentation.self, from: data)
                    self.syncSingleCourse(with: course)
                    completion(nil)
                } catch {
                    NSLog("Error decoding fetched course from database: \(error)")
                    completion(error)
                }
            }
            
        })
    }
    

    
    
    private func loadClass(
        completion: @escaping (Bool,
        Error?) -> Void = { _, _ in }) {
        
        guard let  token = BackendController.token else {
            completion(false, AnywayError.noAuth("UserID hasn't been assigned"))
            return
        }
        let requestURL = baseURL.appendingPathComponent("\(EndPoints.instructorClass.rawValue)")
        var request = URLRequest(url: requestURL)
        request.httpMethod = Method.get.rawValue
        request.setValue(token.token, forHTTPHeaderField: "Authorization")
        
        dataLoader?.loadData(from: request) { data, _, error in
            if let error = error {
                NSLog("Error fetching logged in user's course : \(error)")
                completion(false, error)
                return
            }
            
            guard let data = data else {
                completion(false, AnywayError.badData("Received bad data when fetching logged in user's course array."))
                return
            }
            
            
            let fetchRequest: NSFetchRequest<Course> = Course.fetchRequest()
            
            let handleFetchedClass = BlockOperation {
                do {
                    let decodedClass = try self.decoder.decode([ClassRepresentation].self, from: data)
                    // Check if the user has no posts. And if so return right here.
                    if decodedClass.isEmpty {
                        NSLog("User has no course in the database.")
                        completion(true, nil)
                        return
                    }
                    // If the decoded posts array isn't empty
                    for course in decodedClass {
                        guard let courseID = course.id else { return }
                        // swiftlint:disable all
                        let nsID = NSNumber(integerLiteral: Int(courseID))
                        // swiftlint:enable all
                        fetchRequest.predicate = NSPredicate(format: "id == %@", nsID)
                        // If fetch request finds a post, add it to the array and update it in core data
                        let foundClass = try self.bgContext.fetch(fetchRequest).first
                        if let foundClass = foundClass {
                            self.update(course: foundClass, with: course)
                            // Check if post has already been added.
                            if self.userCourse.first(where: { $0 == foundClass }) != nil {
                                NSLog("Post already added to user's course.")
                            } else {
                                self.userCourse.append(foundClass)
                            }
                        } else {
                            //                             If the post isn't in core data, add it.
                            if let newCourse = Course(representation: course, context: self.bgContext) {
                                if self.userCourse.first(where: { $0 == newCourse }) != nil {
                                    NSLog("Post already added to user's course.")
                                } else {
                                    self.userCourse.append(newCourse)
                                }
                            }
                            //                            try self.savePost(by: id, from: post)
                        }
                    }
                } catch {
                    NSLog("Error Decoding course, Fetching from Coredata: \(error)")
                    completion(false, error)
                }
            }
            
            let handleSaving = BlockOperation {
                // After going through the entire array, try to save context.
                // Make sure to do this in a separate do try catch so we know where things fail
                let handleSaving = BlockOperation {
                    do {
                        // After going through the entire array, try to save context.
                        // Make sure to do this in a separate do try catch so we know where things fail
                        try CoreDataStack.shared.save(context: self.bgContext)
                        completion(false, nil)
                    } catch {
                        NSLog("Error saving context. \(error)")
                        completion(false, error)
                    }
                }
                self.operationQueue.addOperations([handleSaving], waitUntilFinished: true)
            }
            handleSaving.addDependency(handleFetchedClass)
            self.operationQueue.addOperations([handleFetchedClass, handleSaving], waitUntilFinished: true)
        }
    }
    
    
    func updateCourse(at course: Course,
                      name: String,
                      type: String,
                      date: String,
                      startTime: String,
                      duration: String,
                      description: String,
                      intensityLevel: String,
                      location: String,
                      maxClassSize: Int64, completion: @escaping (Error?) -> Void) {
        
        guard let token = BackendController.token else {
            completion(AnywayError.noAuth("User is not logged in."))
            return
        }
        
        let requestURL = baseURL.appendingPathComponent(EndPoints.instructorClass.rawValue).appendingPathComponent("/\(course.id)")
        
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = Method.put.rawValue
        request.setValue(token.token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let dict: [String: Any] = ["name": name,
                                       "type": type,
                                       "date": date,
                                       "startTime": startTime,
                                       "duration": duration,
                                       "overview": description,
                                       "intensityLevel": intensityLevel,
                                       "location": location,
                                       "maxClassSize": maxClassSize,
                                       
            ]
            request.httpBody = try jsonFromDicct(dict: dict)
        } catch {
            NSLog("Error turning dictionary to json: \(error)")
            completion(error)
        }
        
        dataLoader?.loadData(from: request, completion: { data, _, error in
            if let error = error {
                NSLog("Error posting new course to database : \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                completion(AnywayError.badData("Server sent bad data when updating course."))
                return
            }
            
            self.bgContext.perform {
                do {
                    let course = try self.decoder.decode(ClassRepresentation.self, from: data)
                    self.syncSingleCourse(with: course)
                    completion(nil)
                } catch {
                    NSLog("Error decoding fetched course from database: \(error)")
                    completion(error)
                }
            }
            
        })
    }
    
    
    // MARK: - Client Methods
    
    func fetchAllClasses(completion: @escaping ([ClassRepresentation]?, Error?) -> Void) throws {
        
        // If there's no token, user isn't authorized. Throw custom error.
        guard let token = BackendController.token else {
            throw AnywayError.noAuth("No token in controller. User isn't logged in.")
        }
        
        let requestURL = baseURL.appendingPathComponent(EndPoints.clientClass.rawValue)
        var request = URLRequest(url: requestURL)
        request.httpMethod = Method.get.rawValue
        request.setValue(token.token, forHTTPHeaderField: "Authorization")
        
        dataLoader?.loadData(from: request, completion: { data, response, error in
            // Always log the status code response from server.
            if let response = response as? HTTPURLResponse {
                NSLog("Server responded with: \(response.statusCode)")
            }
            
            if let error = error {
                NSLog("Error fetching all existing courses from server : \(error)")
                completion(nil, error)
                return
            }
            
            // use badData when unwrapping data from server.
            guard let data = data else {
                completion(nil, AnywayError.badData("Bad data received from server"))
                return
            }
            
            do {
                let courses = try self.decoder.decode([ClassRepresentation].self, from: data)
                completion(courses, nil)
            } catch {
                NSLog("Couldn't decode array of course from server: \(error)")
                completion(nil, error)
            }
        })
    }
    
    
    func syncCourse(completion: @escaping (Error?) -> Void) {
        var representations: [ClassRepresentation] = []
        do {
            try fetchAllClasses { classes, error in
                if let error = error {
                    NSLog("Error fetching all posts to sync : \(error)")
                    completion(error)
                    return
                }
                
                guard let fetchedClass = classes else {
                    completion(AnywayError.badData("Posts array couldn't be unwrapped"))
                    return
                }
                representations = fetchedClass
                
                // Use this context to initialize new posts into core data.
                self.bgContext.perform {
                    for course in representations {
                        // First if it's in the cache
                        guard let id = course.id else { return }
                        
                        if self.cache.value(for: id) != nil {
                            let cachedCourse = self.cache.value(for: id)!
                            self.update(course: cachedCourse, with: course)
                        } else {
                            do {
                                try self.saveCourse(by: id, from: course)
                            } catch {
                                completion(error)
                                return
                            }
                        }
                    }
                }// context.perform
                completion(nil)
            }// Fetch closure
            
        } catch {
            completion(error)
        }
    }
    
    
     func deleteEntryFromServe(course: Course, completion: @escaping CompletionHandler = { _ in }) {
      
                 
        let requestURL = baseURL.appendingPathComponent(EndPoints.instructorClass.rawValue).appendingPathExtension("\(course.id)")
                 var request = URLRequest(url: requestURL)
        request.httpMethod = Method.delete.rawValue
                 
                 URLSession.shared.dataTask(with: request) { data, response, error in
                     if let error = error {
                         NSLog("Error in getting data: \(error)")
                         completion(.failure(.noData))
                     }
               
                     
                     completion(.success(true))
                 }.resume()
             }
    
    
    
    
    func forceLoadInstructorClass(completion: @escaping (Bool?, Error?) -> Void) {
        loadClass(completion: { isEmpty, error in
            completion(isEmpty, error)
        })
    }
    
    func getReservation(completion: @escaping (Bool?, Error?) -> Void) {
        guard
            let token = BackendController.token else {
                completion(nil, AnywayError.noAuth("User not logged in."))
                return
        }
        
        // Our only DELETE endpoint utilizes query parameters.
        // Must use a new URL to construct commponents
        
        let requestURL = baseURL.appendingPathComponent(EndPoints.clientReservation.rawValue)
        var request = URLRequest(url: requestURL)
        request.httpMethod = Method.get.rawValue
        request.setValue(token.token, forHTTPHeaderField: "Authorization")
        
        dataLoader?.loadData(from: request, completion: { _, response, error in
            if let error = error {
                NSLog("Error from server when attempting to delete. : \(error)")
                completion(nil, error)
                return
            }
            if let response = response as? HTTPURLResponse {
                NSLog("Server responded with: \(response.statusCode)")
            }
            
        })
        
    }
    
    var course: Course?
    func createReservation(_ course: Course, completion: @escaping (Result<[Course], NetworkError>) -> Void) {
          
        guard let token = BackendController.token else { return }
           
        let animalURL = baseURL.appendingPathComponent(EndPoints.clientReservation.rawValue)
        
           var request = URLRequest(url: animalURL)
        request.httpMethod = Method.post.rawValue
          request.setValue(token.token, forHTTPHeaderField: "Authorization")
         
           URLSession.shared.dataTask(with: request) { data, response, error in
               if let error = error {
                   print("failed to fetchh gig with error \(error.localizedDescription)")
                   completion(.failure(.failedFetch))
                   return
               }
               guard let response = response as? HTTPURLResponse,
                   response.statusCode == 200
                   else {
                       print(#file, #function, #line, "fetch gig received bad response")
                       completion(.failure(.failedFetch))
                       return
               }
               self.encoder.dateEncodingStrategy = .iso8601
               
                     do {
                        let jsonData = try self.encoder.encode(course.id)
                         request.httpBody = jsonData
                     } catch {
                         NSLog("Error encoding user object: \(error)")
                         completion(.failure(.badData))
                         return
                     }
               let decoder = JSONDecoder()
               decoder.dateDecodingStrategy = .iso8601
               
               completion(.success([course]))
           }
           .resume()
           
       }
    
    private func jsonFromDicct(dict: [String: Any]) throws -> Data? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            return jsonData
        } catch {
            NSLog("Error Creating JSON From username dictionary. \(error)")
            throw error
        }
    }
    
    private func jsonFromDicct1(dict: String) throws -> Data? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            return jsonData
        } catch {
            NSLog("Error Creating JSON From username dictionary. \(error)")
            throw error
        }
    }
    
    
    
    private func update(course: Course, with rep: ClassRepresentation) {
        course.name = rep.name
        course.type = rep.type
        course.date = rep.date
        course.startTime = rep.startTime
        course.duration = rep.duration
        course.overview = rep.overview
        course.intensityLevel = rep.intensityLevel
        course.location = rep.location
        course.maxClassSize = rep.maxClassSize
    }
    
    private func saveCourse(by userID: Int64, from representation: ClassRepresentation) throws {
        if let newPost = Course(representation: representation, context: bgContext) {
            let handleSaving = BlockOperation {
                do {
                    // After going through the entire array, try to save context.
                    // Make sure to do this in a separate do try catch so we know where things fail
                    try CoreDataStack.shared.save(context: self.bgContext)
                } catch {
                    NSLog("Error saving context.\(error)")
                }
            }
            operationQueue.addOperations([handleSaving], waitUntilFinished: false)
            cache.cache(value: newPost, for: userID)
        }
    }
    
    func syncSingleCourse(with representation: ClassRepresentation) {
        guard let id = representation.id else { return }
        
        if let cachedCourse = self.cache.value(for: id) {
            self.update(course: cachedCourse, with: representation)
        } else {
            do {
                try self.saveCourse(by: id, from: representation)
            } catch {
                NSLog("Error syncinc single post: \(error)")
                return
            }
        }
    }
    
   

    
    private func populateCache() {
        
        // First get all existing posts saved to coreData and store them in the Cache
        let fetchRequest: NSFetchRequest<Course> = Course.fetchRequest()
        // Do this synchronously in the background queue, so that it can't be used until cache is fully populated
        bgContext.performAndWait {
            var fetchResult: [Course] = []
            do {
                fetchResult = try bgContext.fetch(fetchRequest)
            } catch {
                NSLog("Couldn't fetch existing core data posts: \(error)")
            }
            for course in fetchResult {
                cache.cache(value: course, for: course.id)
            }
        }
    }
    
    // MARK: - Enums
    
    private enum AnywayError: Error {
        case noAuth(String)
        case badData(String)
    }
    
    private enum Method: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }
    private enum EndPoints: String {
        case users = "api/user/"
        case userQuery = "api/user/u/search?username="
        case userSearch = "api/user/u/search"
        case instructorClass = "api/instructor/class"
        case clientClass = "api/client/class"
        case register = "api/auth/register"
        case login = "api/auth/login"
        case clientReservation = "/api/client/reservations"
    }
    func injectToken(_ token: String) {
        let token = Token(token: token)
        BackendController.self.token = token
    }
    
    func loggedUserID() -> Int64? {
        // swiftlint:disable all
        return self.instructorId
        // swiftlint:enable all
    }
    
    private func getRequest(for url: URL, bearer: Token) -> URLRequest {
        var request = URLRequest(url: url)
        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
}


class Cache<Key: Hashable, Value> {
    private var cache: [Key: Value] = [ : ]
    private var queue = DispatchQueue(label: "Cache serial queue")
    
    func cache(value: Value, for key: Key) {
        queue.async {
            self.cache[key] = value
        }
    }
    
    func value(for key: Key) -> Value? {
        queue.sync {
            // swiftlint:disable all
            return self.cache[key]
            // swiftlint:enable all
        }
    }
}
