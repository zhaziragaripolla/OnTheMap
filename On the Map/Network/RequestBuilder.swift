//
//  RequestBuilder.swift
//  On the Map
//
//  Created by Zhazira Garipolla on 8/12/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import Foundation

class RequestBuilder {
    
    let baseURL = "https://onthemap-api.udacity.com/v1"
 
    func buildRequest(_ request: Request) -> URLRequest {
        guard var url = URL(string: baseURL + request.path) else {
            fatalError("Failed to build URL")
        }
        
        setQueryParameters(request.query, to: &url)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.map { $0.rawValue }
        setHeaders(request.headers, to: &urlRequest)
        setBodyParameters(request.body, to: &urlRequest)
        return urlRequest
    }
    
    private func setHeaders(_ headers: HTTPHeaders?, to request: inout URLRequest) {
        guard let unwrappedHeaders = headers else { return }
        
        for (key, value) in unwrappedHeaders {
            print(value, key)
            request.addValue(value, forHTTPHeaderField: key)
        }
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    }
    
    private func setBodyParameters(_ parameters: HTTPBodyParameters?, to request: inout URLRequest) {
        guard
            let unwrappedBodyParameters = parameters,
            let body = try? JSONSerialization.data(withJSONObject: unwrappedBodyParameters, options: .prettyPrinted)
            else {
                return
        }
        request.httpBody = body

//        request.httpBody = "{\"udacity\": {\"username\": \"zhumabayeva97@gmail.com\", \"password\": \"Tools003\"}}".data(using: .utf8)
    }
    
    private func setQueryParameters(_ parameters: HTTPQueryParameters?, to url: inout URL) {
        guard
            let unwrappedQueryParameters = parameters,
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
            else {
                return
        }
        
        
        urlComponents.queryItems = unwrappedQueryParameters.compactMap({ (value) -> URLQueryItem? in
            return URLQueryItem(name: value.key, value: value.value)
        })
        
        if let unwrappedURL = urlComponents.url {
            url = unwrappedURL
        }
    }
}
