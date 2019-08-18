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
    
    var baseHeaders = [
        "Accept": "application/json",
        "Content-Type": "application/json",
        "X-Parse-Application-Id": "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr",
        "X-Parse-REST-API-Key" : "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    ]
    
    // MARK: Create a session
    func createSession(login: String, password: String)-> URLRequest{
        let body: HTTPBodyParameters = [
            "udacity" : ["username": "\(login)", "password": "\(password)"]
        ]
        return requestBuilder.buildRequest(path: "/session", method: .POST, headers: baseHeaders, body: body, query: nil)
    }
    
    // MARK: Delete session
    func deleteSession()-> URLRequest {
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        
        let headers: HTTPHeaders = [ "XSRF-TOKEN" : xsrfCookie!.description]
        
        return requestBuilder.buildRequest(path: "/session", method: .DELETE, headers: headers, body: nil, query: nil)
    }
  
    // MARK: Get user data
    func getUserData()-> URLRequest {
        return requestBuilder.buildRequest(path: "/users/" + Auth.accountKey, method: .GET, headers: nil, body: nil, query: nil)
    }
    
    // MARK: Get 100 recent student locations
    func getStudentLocations() -> URLRequest {
        let query = ["limit" : "100", "skip" : "0", "order" : "-updatedAt"]
        return requestBuilder.buildRequest(path: "/StudentLocation", method: .GET, headers: nil, body: nil, query: query)
    }
    
    // MARK: Post new location
    func postStudentLocation(_ location: StudentLocationRequest)-> URLRequest {
        
        let body: HTTPBodyParameters = [
            "uniqueKey" : location.uniqueKey,
            "firstName" : location.firstName,
            "lastName" : location.lastName,
            "mapString" : location.mapString,
            "mediaURL" : location.mediaURL,
            "latitude" : location.latitude,
            "longitude" : location.longitude
        ]
        
        return requestBuilder.buildRequest(path: "/StudentLocation", method: .POST, headers: baseHeaders, body: body, query: nil)
    }
    
    // MARK: Put student location
    func putStudentLocation(_ location: StudentLocation)-> URLRequest {
        
        let body: HTTPBodyParameters = [
            "uniqueKey" : location.uniqueKey,
            "firstName" : location.firstName,
            "lastName" : location.lastName,
            "mapString" : location.mapString,
            "mediaURL" : location.mediaURL,
            "latitude" : location.latitude,
            "longitude" : location.longitude
        ]
        
        return requestBuilder.buildRequest(path: "/StudentLocation/\(location.objectId)", method: .PUT, headers: baseHeaders, body: body, query: nil)
    }

}
