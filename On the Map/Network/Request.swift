//
//  Request.swift
//  On the Map
//
//  Created by Zhazira Garipolla on 8/12/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import Foundation

typealias HTTPHeaders = [String: String]
typealias HTTPBodyParameters = [String: Any]
typealias HTTPQueryParameters = [String: String]

enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}
