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
                                        email: String,
                                        firstname: String,
                                        lastname: String,
                                        role: String,
                                        password: String,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        self.id = id
        self.email = email
        self.firstname = firstname
        self.lastname = lastname
        self.role = role
        self.password = password
        
        
    }
}
