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
    
     let bgContext = CoreDataStack.shared.container.newBackgroundContext()
}
