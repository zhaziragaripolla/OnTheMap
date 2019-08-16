//
//  ParseErrorResponse.swift
//  On the Map
//
//  Created by Zhazira Garipolla on 8/16/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import Foundation

struct ParseErrorResponse: Codable {
    let statusCode: Int
    let errorMessage: String
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "code"
        case errorMessage = "error"
    }
}

extension ParseErrorResponse: LocalizedError {
    
    var errorDescription: String? {
        return errorMessage
    }
}
