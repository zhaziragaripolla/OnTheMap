//
//  RequestProvider.swift
//  On the Map
//
//  Created by Zhazira Garipolla on 8/12/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import Foundation

class RequestProvider {
    let requestBuilder = RequestBuilder()

    func getStudentLocations() -> URLRequest {
        return requestBuilder.buildRequest(path: "/StudentLocation", method: .GET, headers: nil, body: nil, query: nil)
    }
    
    func createSession(login: String, password: String)-> URLRequest{
        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        let body: HTTPBodyParameters = [
            "udacity" : ["username": "\(login)", "password": "\(password)"]
        ]
        return requestBuilder.buildRequest(path: "/session", method: .POST, headers: headers, body: body, query: nil)
    }
    
    func getUserData()-> URLRequest {
        return requestBuilder.buildRequest(path: "/users/" + Auth.accountKey, method: .GET, headers: nil, body: nil, query: nil)
    }
    
    func postStudentLocation(location: String, mediaURL: String, latitude: Float, longtitude: Float)-> URLRequest {
        let headers = [
            "Accept": "application/json",
            "Content-Type": "application/json",
            "X-Parse-Application-Id": "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr",
            "X-Parse-REST-API-Key" : "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        ]

        let body: HTTPBodyParameters = [
            "uniqueKey" : Auth.accountKey,
            "firstName" : User.firstName,
            "lastName" : User.lastName,
            "mapString" : location,
            "mediaURL" : mediaURL,
            "latitude" : 37.386052,
            "longtitude" : -122.083851
        ]
        return requestBuilder.buildRequest(path: "/StudentLocation", method: .POST, headers: headers, body: body, query: nil)
    }

}
