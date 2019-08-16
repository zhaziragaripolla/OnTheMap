//
//  StudentLocationRequest.swift
//  On the Map
//
//  Created by Zhazira Garipolla on 8/16/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import Foundation

struct StudentLocationRequest: Codable {
    let firstName: String
    let lastName: String
    let mapString: String
    let latitude: Float
    let longitude: Float
    let mediaURL: String
    let uniqueKey: String
}
