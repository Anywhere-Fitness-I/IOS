//
//  UserRepresentation.swift
//  AnywhereFitness
//
//  Created by Bhawnish Kumar on 5/24/20.
//  Copyright © 2020 Bhawnish Kumar. All rights reserved.
//

import Foundation


struct UserRepresentation: Codable {
    
    var id: Int64?
    var firstName: String
    var lastName: String
    var email: String
    var password: String
    var role: String
    
    private enum CodingKeys: String, CodingKey {
        
        case firstName
        case lastName
        case email
        case password
        case role
        case id
        
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(email, forKey: .email)
        try container.encode(password, forKey: .password)
        try container.encode(role, forKey: .role)
    }
    
    init(firstName: String, lastName: String, email: String, password: String, role: String, id: Int64? = nil) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.password = password
        self.role = role
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let decodedID = try container.decode(Int.self, forKey: .id)
        id = Int64(decodedID)
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .firstName)
        email = try container.decode(String.self, forKey: .email)
        password = try container.decode(String.self, forKey: .password)
        role = try container.decode(String.self, forKey: .role)
        
    }
}
