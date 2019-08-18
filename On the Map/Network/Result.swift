//
//  Result.swift
//  On the Map
//
//  Created by Zhazira Garipolla on 8/18/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case clientError
    case serverError
    case dataMissed
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .serverError:
            return "There is a server error. Try again later."
        case .dataMissed:
            return "Data is missed."
        case .clientError:
            return "Invalid email or password."
        }
    }
}

enum Result<T: Codable> {
    case success(response: T)
    case failure(error: Error)
}
