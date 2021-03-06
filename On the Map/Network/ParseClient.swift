//
//  ParseClient.swift
//  On the Map
//
//  Created by Zhazira Garipolla on 8/16/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import Foundation

class ParseClient {
    
    func makeRequest<T: Codable>(_ request: URLRequest, responseType: T.Type, callback: @escaping (Result<T>) -> ()){
        let dataTask = URLSession.shared.dataTask(with: request) {(data, response, error) in
            if let error = error {
                callback(.failure(error: error))
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 400...451:
                    DispatchQueue.main.async {
                        callback(.failure(error: NetworkError.clientError))
                    }
                case 500...511:
                    DispatchQueue.main.async {
                        callback(.failure(error: NetworkError.serverError))
                    }
                default:
                    break
                }
            }
            
            guard let unwrappedData = data else {
                DispatchQueue.main.async {
                    callback(.failure(error: NetworkError.dataMissed))
                }
                return
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .formatted(Formatter.iso8601)
            
            do {
                let response = try decoder.decode(T.self, from: unwrappedData)
                DispatchQueue.main.async {
                    callback(.success(response: response))
                    
                }
                
            } catch {
                do {
                    let errorResponse = try decoder.decode(ParseErrorResponse.self, from: unwrappedData)
                    
                    DispatchQueue.main.async {
                        print(errorResponse.errorMessage)
                        callback(.failure(error: errorResponse))
                    }
                } catch {
                    DispatchQueue.main.async {
                        callback(.failure(error: error))
                    }
                }
                
            }
            
        }
        
        dataTask.resume()
    }
}
