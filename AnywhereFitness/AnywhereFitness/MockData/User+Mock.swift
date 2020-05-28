//
//  User+Mock.swift
//  AnywhereFitness
//
//  Created by Bhawnish Kumar on 5/24/20.
//  Copyright © 2020 Bhawnish Kumar. All rights reserved.
//

import Foundation

let validUserJSON = """
{
  "message": "Welcome Bharat!",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWJqZWN0Ijo2LCJyb2xlIjoiY2xpZW50IiwiaWF0IjoxNTkwMzY2ODEyLCJleHAiOjE1OTI5NTg4MTJ9.yWW-XhXpmn9K0rSpK5LkoWUdft5VjkNm5hvLSCZnK2Q",
  "user": {
    "id": 6,
    "firstName": "Bharat",
    "lastName": "Kumar",
    "email": "test12@test12.com",
    "role": "client"
  }
}
""".data(using: .utf8)

let invalidUserJSON = """
{
  "id": ,
  "username": "tim_the_enchanter,
  "password": "$2a$12$K4DW2jDwOORS5AN/qGYA..I.b1RZUBzqlIwpg2BJIIIBYASABTTAu",
  "email": "enchanter_tim@gmail.com"
}
""".data(using: .utf8)

let validLoginJSON = """
{
    "username":"tim_the_enchanter",
    "password":"123abc"
}
""".data(using: .utf8)
