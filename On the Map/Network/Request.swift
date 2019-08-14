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

struct Request {
    let path: String
    let method: HTTPMethod?
    let headers: HTTPHeaders?
    let body: HTTPBodyParameters?
    let query: HTTPQueryParameters?
    
    init(path: String,
         method: HTTPMethod? = nil,
         headers: HTTPHeaders? = nil,
         body: HTTPBodyParameters? = nil,
         query: HTTPQueryParameters? = nil) {
        
        self.path = path
        self.method = method
        self.headers = headers
        self.body = body
        self.query = query
    }
}
