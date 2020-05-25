//
//  BackendController.swift
//  AnywhereFitness
//
//  Created by Bhawnish Kumar on 5/22/20.
//  Copyright © 2020 Bhawnish Kumar. All rights reserved.
//

import Foundation

class BackendController {
    
    private var baseURL: URL = URL(string: "https://anywhere-fit.herokuapp.com/")!
    
    private var encoder = JSONEncoder()
    private var decoder = JSONDecoder()
    private var token: Token?
    var dataLoader: DataLoader?
    
    let bgContext = CoreDataStack.shared.container.newBackgroundContext()
    
    init(dataLoader: DataLoader = URLSession.shared) {
        self.dataLoader = dataLoader
        
    }
    
    var isSignedIn: Bool {
        // swiftlint: disable all
        return token != nil
        // swiftlint: enable all
    }
    
    func signUp(firstName: String, lastName: String, email: String, password: String, role: [String], completion: @escaping (Bool, URLResponse?, Error?) -> Void) {
        
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
                    self.token = tokenResult
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
        let requestURL = baseURL.appendingPathComponent(EndPoints.userSearch.rawValue)
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
                let error = HowtoError.badData("Invalid data returned from searching for a specific user.")
                completion(error)
                return
            }

            do {
                if let decodedUser = try self.decoder.decode([UserRepresentation].self, from: data).first {
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
    
    
    //MARK: - Enums
    
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
