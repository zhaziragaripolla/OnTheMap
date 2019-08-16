//
//  UdacityResponse.swift
//  On the Map
//
//  Created by Zhazira Garipolla on 8/14/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import Foundation

struct UdacityResponse: Codable {
    let account: Account
    let session: Session
}

struct Account: Codable {
    let registered: Bool
    let key: String
}

struct Session: Codable {
    let id: String
    let expiration: Date
}

struct UdacityErrorResponse: Codable {
    let statusCode: Int
    let errorMessage: String
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status"
        case errorMessage = "error"
    }
}

extension UdacityErrorResponse: LocalizedError {

    var localizedDescription: String? {
        return self.errorMessage
    }
}
