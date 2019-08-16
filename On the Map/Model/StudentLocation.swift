//
//  StudentLocation.swift
//  On the Map
//
//  Created by Zhazira Garipolla on 8/12/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import Foundation

struct StudentLocation: Codable {
    var objectId: String?
    var uniqueKey: String?
    var firstName: String
    var lastName: String
    var mapString: String
    var latitude: Float
    var longitude: Float
    var createdAt: Date?
    var updatedAt: Date?
    var mediaURL: String?
}
