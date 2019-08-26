//
//  User.swift
//  On the Map
//
//  Created by Zhazira Garipolla on 8/14/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import Foundation

struct User {
    static var firstName = "Joe"
    static var lastName = "Doe"
}

struct UserResponse: Codable {
    let firstName: String
    let lastName: String
}
