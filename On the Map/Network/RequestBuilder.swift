//
//  RequestBuilder.swift
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

class RequestBuilder {
    
    let baseURL = "https://onthemap-api.udacity.com/v1"
 
    func buildRequest(path: String,
                      method: HTTPMethod? = nil,
                      headers: HTTPHeaders? = nil,
                      body: HTTPBodyParameters? = nil,
                      query: HTTPQueryParameters? = nil) -> URLRequest {
        guard var url = URL(string: baseURL + path) else {
            fatalError("Failed to build URL")
        }
        
        setQueryParameters(query, to: &url)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.map { $0.rawValue }
        setHeaders(headers, to: &urlRequest)
        setBodyParameters(body, to: &urlRequest)
        
        return urlRequest
    }
    
    private func setHeaders(_ headers: HTTPHeaders?, to request: inout URLRequest) {
        guard let unwrappedHeaders = headers else { return }
        
        for (key, value) in unwrappedHeaders {
            request.addValue(value, forHTTPHeaderField: key)
        }
    }
    
    private func setBodyParameters(_ parameters: HTTPBodyParameters?, to request: inout URLRequest) {
        guard
            let unwrappedBodyParameters = parameters,
            let body = try? JSONSerialization.data(withJSONObject: unwrappedBodyParameters, options: .prettyPrinted)
            else {
                return
        }
        request.httpBody = body
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
