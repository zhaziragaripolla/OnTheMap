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
    
//    var localizedDescription: String {
//        switch self {
//        case .serverError:
//            return "The server could "
//        default:
//            return ""
//        }
//    }
}

enum Result<T: Codable> {
    case success(response: T)
    case failure(error: Error)
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
