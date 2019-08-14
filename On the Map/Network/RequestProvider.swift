//
//  RequestProvider.swift
//  On the Map
//
//  Created by Zhazira Garipolla on 8/12/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import Foundation

class RequestProvider {
//    var baseHeaders: HTTPHeaders {
//        return [
//            "Authorization": "Client-ID \(Credentials.clientID)"
//        ]
//    }

    func getStudentLocations() -> Request {
        return Request(path: "/StudentLocation", method: .GET, headers: nil, body: nil, query: nil)
    }
    
    func createSession(login: String, password: String)-> Request {
        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        let body: HTTPBodyParameters = [
            "udacity" : ["username": "\(login)", "password": "\(password)"]
        ]
        return Request(path: "/session", method: .POST, headers: headers, body: body, query: nil)
    }
    
//    func makeGetCollectionsRequest(page: Int) -> Request {
//        let params: HTTPQueryParameters = [
//            "page": page.description
//        ]
//
//        return Request(path: "/collections", method: .GET, headers: baseHeaders, query: params)
//    }
}
