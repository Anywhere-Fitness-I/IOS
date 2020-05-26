//
//  Class+Convenience.swift
//  AnywhereFitness
//
//  Created by Bhawnish Kumar on 5/26/20.
//  Copyright © 2020 Bhawnish Kumar. All rights reserved.
//

import Foundation
import CoreData


//name
//type
//date
//startTime
//duration
//description
//intensityLevel
//location
//maxClassSize
extension Class {
    
    @discardableResult convenience init(id: Int64,
                                        name: String,
                                        type: String,
                                        date: String,
                                        startTime: String,
                                        duration: String,
                                        overview: String,
                                        intensityLevel: String,
                                        location: String,
                                        maxClassSize: Int64,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        self.id = id
        self.name = name
        self.type = type
        self.date = date
        self.startTime = startTime
        self.duration = duration
        self.overview = overview
        self.intensityLevel = intensityLevel
        self.location = location
        self.maxClassSize = maxClassSize
        
    }
    @discardableResult convenience init?(representation: ClassRepresentation,
                                         context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {

        guard let id = representation.id else {
            NSLog("Representation passed in with invalid id")
            return nil
        }
        self.init(id: id,
                  name: representation.name,
                  type: representation.type,
                  date: representation.date,
                  startTime: representation.startTime,
                  duration: representation.duration,
                  overview: representation.description,
                  intensityLevel: representation.intensityLevel,
                  location: representation.location,
                  maxClassSize: representation.maxClassSize,
                  context: context)
    }
}
