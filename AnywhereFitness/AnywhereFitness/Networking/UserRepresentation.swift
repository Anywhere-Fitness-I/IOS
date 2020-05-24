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
    var firstname: String
    var lastname: String
    var email: String
    var password: String?
    var role: String
    
    init(email: String, firstname: String, lastname: String, password: String, id: Int64 = nil) {
        self.id
    }
}
