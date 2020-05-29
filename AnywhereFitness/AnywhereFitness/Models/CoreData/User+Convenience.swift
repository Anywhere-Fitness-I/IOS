//
//  User+Convenience.swift
//  AnywhereFitness
//
//  Created by Bhawnish Kumar on 5/22/20.
//  Copyright © 2020 Bhawnish Kumar. All rights reserved.
//

import Foundation
import CoreData


extension User {
    
    @discardableResult convenience init(id: Int64,
                                        firstName: String,
                                        lastName: String,
                                        email: String,
                                        password: String,
                                        role: String,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.password = password
        self.role = role
    }
    
    @discardableResult convenience init?(representation: UserRepresentation,
                                         context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {

        guard let id = representation.id else {
            NSLog("Representation passed in with invalid id")
            return nil
        }
        self.init(id: id,
                  firstName: representation.firstName,
                  lastName: representation.lastName,
                  email: representation.email,
                  password: representation.password,
                  role: representation.role,
                  context: context)
    }

}
