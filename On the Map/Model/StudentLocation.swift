//
//  StudentLocation.swift
//  On the Map
//
//  Created by Zhazira Garipolla on 8/12/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import Foundation

struct StudentLocation: Codable {
    let firstName: String
    let lastName: String
    let mapString: String
    let latitude: Float
    let longitude: Float
    let mediaURL: String?
    let objectId: String?
    let uniqueKey: String?
}
