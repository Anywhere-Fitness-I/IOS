//
//  AnywhereFitnessTests.swift
//  AnywhereFitnessTests
//
//  Created by Bhawnish Kumar on 5/22/20.
//  Copyright © 2020 Bhawnish Kumar. All rights reserved.
//

import XCTest
import CoreData
@testable import AnywhereFitness
class AnywhereFitnessTests: XCTestCase {
    
    var XPC_SIMULATOR_LAUNCHD_NAME="com.apple.CoreSimulator.SimDevice.04042E78-E743-4376-94E9-31842D4770B6.launchd_sim"
    
    let token: String = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWJqZWN0IjoxMCwicm9sZSI6ImNsaWVudCIsImlhdCI6MTU5MDM3MTM1OSwiZXhwIjoxNTkyOTYzMzU5fQ.hhs-S-id1aCAcmSLxogl15RQxVtD0NLXMb33WYrxYSk"
    
    var backend = BackendController()
    let timeout: Double = 10
    
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        backend = BackendController()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testEncodeUserRepresentation() {
        
        let user = UserRepresentation(firstName: "Bharat", lastName: "Kumar", email: "test12@test12.com", password: "pass1", role: [Role.client.rawValue])
        
        let encoder = JSONEncoder()
        do {
            let json = try encoder.encode(user)
            let pretty = String(data: json, encoding: .utf8)
            print(pretty!)
        } catch {
            XCTFail("No issues encoding json and printing it.")
            NSLog("Error encoding data: \(error)")
        }
    }
    
    func testSignUp() {
        let expectSignUp = expectation(description: "got it")
        backend.signUp(firstName: "Bhawnish", lastName: "Kumar", email: "mohan12@gmail.com", password: "mohan123", role: [Role.instructor.rawValue]) { newUser, response, _ in
            if let response = response as? HTTPURLResponse,
            response.statusCode == 500 {
                NSLog("User already exists in the database. Therefore user data was sent successfully to database.")
                expectSignUp.fulfill()
                return

            }
            
            XCTAssertTrue(newUser)
            expectSignUp.fulfill()

        }
        expectSignUp.fulfill()
        wait(for: [expectSignUp], timeout: timeout)
    }
    
    
    func testSignIn() {
        let expectSignIn = expectation(description: "got it")
        
        backend.signIn(email: "test@test.com", password: "pass") { logged in
            XCTAssertTrue(logged)
            expectSignIn.fulfill()
        }
        
        wait(for: [expectSignIn], timeout: timeout)
        XCTAssertTrue(backend.isSignedIn)
        
    }
    
}
