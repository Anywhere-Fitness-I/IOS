//
//  ClassRepresentation.swift
//  AnywhereFitness
//
//  Created by Bhawnish Kumar on 5/26/20.
//  Copyright © 2020 Bhawnish Kumar. All rights reserved.
//

import Foundation

//name
//type
//date
//startTime
//duration
//description
//intensityLevel
//location
//maxClassSize
class ClassRepresentation: Codable {
    
    var id: Int64?
    var name: String
    var type: String
    var date: String
    var startTime: String
    var duration: String
    var description: String
    var intensityLevel: String
    var location: String
    var maxClassSize: Int64
    var instructorId: Int64?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case type
        case date
        case startTime
        case duration
        case description
        case intensityLevel
        case location
        case maxClassSize
        case instructorId
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(type, forKey: .type)
        try container.encode(date, forKey: .date)
        try container.encode(startTime, forKey: .startTime)
        try container.encode(duration, forKey: .duration)
        try container.encode(description, forKey: .description)
        try container.encode(intensityLevel, forKey: .intensityLevel)
        try container.encode(location, forKey: .location)
        try container.encode(maxClassSize, forKey: .maxClassSize)
        try container.encode(instructorId, forKey: .instructorId)
        
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int64.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        type = try container.decode(String.self, forKey: .type)
        date = try container.decode(String.self, forKey: .date)
        startTime = try container.decode(String.self, forKey: .startTime)
        duration = try container.decode(String.self, forKey: .duration)
        description = try container.decode(String.self, forKey: .description)
        intensityLevel = try container.decode(String.self, forKey: .intensityLevel)
        location = try container.decode(String.self, forKey: .location)
        maxClassSize = try container.decode(Int64.self, forKey: .maxClassSize)
        instructorId = try container.decode(Int64.self, forKey: .instructorId)
    }
    
}
