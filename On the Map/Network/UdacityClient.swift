//
//  UdacityClient.swift
//  On the Map
//
//  Created by Zhazira Garipolla on 8/16/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import Foundation


class UdacityClient {
    
    let cookies: [HTTPCookie] = []
    func makeRequest<T: Codable>(_ request: URLRequest, responseType: T.Type, callback: @escaping (Result<T>) -> ()) {
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                callback(.failure(error: error))
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print(httpResponse.statusCode)
                switch httpResponse.statusCode {
                
                case 500...511:
                    DispatchQueue.main.async {
                        callback(.failure(error: NetworkError.serverError))
                    }
                    
                default:
                    break
                }
                let fields = httpResponse.allHeaderFields
                let cookies = HTTPCookie.cookies(withResponseHeaderFields: fields as! [String : String], for: (response?.url!)!)
                HTTPCookieStorage.shared.setCookies(cookies, for: response?.url, mainDocumentURL: nil)
            }
            
            guard var unwrappedData = data else {
                callback(.failure(error: NetworkError.dataMissed))
                return
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .formatted(Formatter.iso8601)
            
            let cleanData = unwrappedData.subdata(in: 5..<unwrappedData.count)
            
            do {
                //                print(String(data: unwrappedData, encoding: .utf8))
                
                let response = try decoder.decode(T.self, from: cleanData)
                DispatchQueue.main.async {
                    callback(.success(response: response))
                    
                }
                
            } catch {
                do {
                    let errorResponse = try decoder.decode(UdacityErrorResponse.self, from: unwrappedData)
                    
                    DispatchQueue.main.async {
                        print(errorResponse.errorMessage)
                        callback(.failure(error: errorResponse))
                    }
                } catch {
                    print(error.localizedDescription)
                    DispatchQueue.main.async {
                        callback(.failure(error: error))
                    }
                }
                
            }
            
        }
        
        dataTask.resume()
        
    }
    
}