//
//  UserModel.swift
//  AnywhereFitness
//
//  Created by Bhawnish Kumar on 5/24/20.
//  Copyright © 2020 Bhawnish Kumar. All rights reserved.
//

import Foundation


struct UserLogin: Codable {
    let firstName: String
    let lastName: String
    let email: String
    let password: String
    let roles: [String]
}

enum Role: String, Codable {
    case instructor
    case client
}
