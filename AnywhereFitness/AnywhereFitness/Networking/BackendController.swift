//
//  BackendController.swift
//  AnywhereFitness
//
//  Created by Bhawnish Kumar on 5/22/20.
//  Copyright © 2020 Bhawnish Kumar. All rights reserved.
//

import Foundation

class BackendController {
    
    private var baseURL: URL = URL(string: "https://anywhere-fit.herokuapp.com")!
    
    private var encoder = JSONEncoder()
    private var decoder = JSONDecoder()
    private var token: Token?
    var dataLoader: DataLoader?
    
    let bgContext = CoreDataStack.shared.container.newBackgroundContext()
    
    init(dataLoader: DataLoader = URLSession.shared) {
        self.dataLoader = dataLoader
        
    }
    
    func signUp(firstName: String, lastName: String, email: String, password: String, role: String, completion: @escaping (Bool, URLResponse?, Error?) -> Void) {
        
        let newUser = UserRepresentation(firstName: firstName, lastName: lastName, email: email, password: password, role: role)
        
        let requestURL = baseURL.appendingPathComponent(EndPoints.register.rawValue)
        var request = URLRequest(url: requestURL)
        request.httpMethod = Method.get.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            
            // Try to encode the newly created user into the request body.
            let jsonData = try encoder.encode(newUser)
            request.httpBody = jsonData
        } catch {
            NSLog("Error encoding newly created user: \(error)")
            return
        }
        
        dataLoader?.loadData(from: request) { data, response, error in
            
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
            
            guard let data = data else { return }
            
            do {
                _ = try self.decoder.decode(UserRepresentation.self, from: data)
            } catch {
                NSLog("Error decoding data: \(error)")
                completion(false, nil, error)
            }
            
            // We'll only get down here if everything went right
            completion(true, nil, nil)
        }
    }
    
    
    
    //    MARK: - Enums
    
    private enum HowtoError: Error {
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
        self.token = token
    }
    
}
