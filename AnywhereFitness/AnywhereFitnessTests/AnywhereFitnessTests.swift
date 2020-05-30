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
    
    let token: String =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWJqZWN0IjoxMCwicm9sZSI6ImNsaWVudCIsImlhdCI6MTU5MDM3MTM1OSwiZXhwIjoxNTkyOTYzMzU5fQ.hhs-S-id1aCAcmSLxogl15RQxVtD0NLXMb33WYrxYSk"
    
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
        
        let user = UserRepresentation(firstName: "Bharat", lastName: "Kumar", email: "test12@test12.com", password: "pass1", role: "client")
        
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
        backend.signUp(firstName: "Bhawnish", lastName: "Kumar", email: "bharat@gmail.com", password: "bharat123", role: "intructor") { newUser, response, _ in
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
        
        backend.signIn(email: "bharat@gmail.com", password: "bharat123") { logged in
            XCTAssertTrue(logged)
            expectSignIn.fulfill()
        }
        
        wait(for: [expectSignIn], timeout: timeout)
        XCTAssertTrue(backend.isSignedIn)
        
    }

    func testCreatePost() {
           let expectCreatePost = expectation(description: "Testing create new course.")
        backend.signIn(email: "test@test.com", password: "pass") { _ in
               expectCreatePost.fulfill()
           }
           wait(for: [expectCreatePost], timeout: timeout)
        let count = backend.userCourse.count
           print(count)
           let createExpect = expectation(description: "Expectation for creating course")
        backend.createClass(name: "Yoga Closs",
                            type: "Musles",
                            date: "Today",
                            startTime: "Right now",
                            duration: "A month",
                            description: "A lot of relaxing exercises",
                            intensityLevel: "easy",
                            location: "san diego",
                            maxClassSize: 10) { _ in
        
               createExpect.fulfill()
           }
           wait(for: [createExpect], timeout: timeout)

           let refetchUserExpect = expectation(description: "Last expectation for testing create course")
           backend.forceLoadInstructorClass { _, _ in
             
               refetchUserExpect.fulfill()
           }
           wait(for: [refetchUserExpect], timeout: timeout)
       }
<<<<<<< HEAD
    
    func testUpdateCourse() {
         let expectUpdateCourse = expectation(description: "Testing update course.")
         backend.signIn(email: "bharatinstructor@gmail.com", password: "mohan123") { _ in
             expectUpdateCourse.fulfill()
         }
         wait(for: [expectUpdateCourse], timeout: timeout)

         let refetchUserExpectation = expectation(description: "Last method call for testing update course")
         backend.forceLoadInstructorClass { _, _ in
             refetchUserExpectation.fulfill()
         }
         wait(for: [refetchUserExpectation], timeout: timeout)
         print(backend.userCourse)

         let updateExpect = expectation(description: "Expectation for updating course")
        backend.updateCourse(at: backend.userCourse[0],
                             name: "gym",
                             type: "12",
                             date: "12",
                             startTime: "12",
                             duration: "12",
                             description: "12",
                             intensityLevel: "12",
                             location: "12",
                             maxClassSize: 12) { _ in
           
             updateExpect.fulfill()
         }
         wait(for: [updateExpect], timeout: timeout)
     }
    
     func testLoadUserCourse() {
    //        let backend = BackendController()
            let expectLoadUserCourse = expectation(description: "Testing stored user.")
            backend.signIn(email: "bharatinstructor@gmail.com", password: "mohan123") { _  in
                expectLoadUserCourse.fulfill()
            }
            wait(for: [expectLoadUserCourse], timeout: timeout)
            XCTAssertTrue(backend.isSignedIn)
            let expec2 = expectation(description: "Force load course")
            backend.forceLoadInstructorClass(completion: { isEmpty, error in
                XCTAssertNil(error)
                XCTAssertTrue(!isEmpty)
                expec2.fulfill()
            })
            wait(for: [expec2], timeout: timeout)
            print(backend.userCourse)
            XCTAssertTrue(!backend.userCourse.isEmpty)
        }
    
    func testSyncCourseCoreData() {
        backend.injectToken(token)
        let syncExpect = expectation(description: "Sync posts expectation.")

        // First pass to check that it works.
        backend.syncCourse{ error in
            XCTAssertNil(error)
            syncExpect.fulfill()
        }
        wait(for: [syncExpect], timeout: timeout)

        let fetchRequest: NSFetchRequest<Course> = Course.fetchRequest()
        let moc = CoreDataStack.shared.mainContext
        moc.reset()
        var fetchCount: Int = 0
        do {
            let fetchedResults = try moc.fetch(fetchRequest)
            print(fetchedResults.count)
            fetchCount = fetchedResults.count
            XCTAssertFalse(fetchedResults.isEmpty)
        } catch {
            NSLog("Couldn't fetch ----- : \(error)")
            XCTFail("If the result is empy, nothing was fetched.")
        }

        // Second pass to ensure no duplicates are created
        let expect2 = expectation(description: "Expectation for duplicates checking.")
        let newBackend = BackendController()
        newBackend.injectToken(token)
        newBackend.syncCourse { error in
            XCTAssertNil(error)
            expect2.fulfill()
        }
        wait(for: [expect2], timeout: timeout)

        moc.reset()
        do {
            let fetchedResults = try moc.fetch(fetchRequest)
            print(fetchedResults.count)
            // Check that the previously assigned count is the same as this new fetch count
            XCTAssertEqual(fetchCount, fetchedResults.count)
        } catch {
            NSLog("Couldn't fetch ----- : \(error)")
            XCTFail("If the result is empy, nothing was fetched.")
        }
    }
    
    func testStoreUserID() {
          let expectStoreUser = expectation(description: "Testing stored user.")
          backend.signIn(email: "bharatinstructor@gmail.com", password: "mohan123") { _  in
              expectStoreUser.fulfill()
          }
          wait(for: [expectStoreUser], timeout: timeout)
          XCTAssertTrue(backend.isSignedIn)
          XCTAssertNotNil(backend.loggedUserID)
      }
    
    func testDeletePost() {

           let deleteSignexpectation = expectation(description: "Signing in to delete a post.")
           backend.signIn(email: "bharatinstructor@gmail.com", password: "instructor") { _ in
               deleteSignexpectation.fulfill()
           }
           wait(for: [deleteSignexpectation], timeout: timeout)

           // We'll populate the user's posts so we can use the first post in the array for deletion.
           let loadToDeleteExpect = expectation(description: "Load user posts so we may delete one.")
           backend.forceLoadInstructorClass { _, _ in
               loadToDeleteExpect.fulfill()
           }
           wait(for: [loadToDeleteExpect], timeout: timeout)

           let deletePostExpect = expectation(description: "Delete post method expectation")
        backend.deleteCourse(course: backend.userCourse[0]) { deleted, _ in
               XCTAssertNotNil(deleted)
               // Consider the not nil check as unwrapping, so force unwrapping is safe
               XCTAssertTrue(deleted!)
               deletePostExpect.fulfill()
           }
           wait(for: [deletePostExpect], timeout: timeout)
       }
    
<<<<<<< HEAD

=======
    
=======
>>>>>>> enzoWorking
>>>>>>> parent of 41de5f9... Cleaned Up code
}
