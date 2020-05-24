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
  "id": 5,
  "username": "tim_the_enchanter",
  "password": "$2a$12$K4DW2jDwOORS5AN/qGYA..I.b1RZUBzqlIwpg2BJIIIBYASABTTAu",
  "email": "enchanter_tim@gmail.com"
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
