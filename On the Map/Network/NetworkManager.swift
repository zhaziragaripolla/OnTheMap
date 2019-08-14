//
//  NetworkManager.swift
//  On the Map
//
//  Created by Zhazira Garipolla on 8/12/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case clientError
    case serverError
    case dataMissed
}

enum Result<T: Codable> {
    case success(response: T)
    case failure(error: Error)
}

class NetworkManager {
//    static let shared = NetworkManager()
//
//    private init(){}
    private var currentTask: URLSessionDataTask?
    
    
    func makeRequest<T: Codable>(_ request: URLRequest, responseType: T.Type, isSkippingChars: Bool, callback: @escaping (Result<T>) -> ()) {
        
        let dataTask = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            if let error = error {
                callback(.failure(error: error))
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print(httpResponse.statusCode)
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
            
            guard var unwrappedData = data else {
                callback(.failure(error: NetworkError.dataMissed))
                return
            }
            
            do {
                // skip first 4 characters for decoding Udacity API's responses
                if isSkippingChars {
                    unwrappedData = unwrappedData.subdata(in: 5..<unwrappedData.count)
                }
                
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                jsonDecoder.dateDecodingStrategy = .formatted(Formatter.iso8601)
                let response = try jsonDecoder.decode(T.self, from: unwrappedData)
                DispatchQueue.main.async {
                    callback(.success(response: response))
                }
                
            } catch {
                DispatchQueue.main.async {
                    callback(.failure(error: error))
                }
                
            }
        
            
            self?.currentTask = nil
        }
        
        dataTask.resume()
        currentTask = dataTask
    }
    
    
    
    func resume() {
        currentTask?.resume()
    }
    
    func suspend() {
        currentTask?.suspend()
    }
}

extension Formatter {
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }()
}
