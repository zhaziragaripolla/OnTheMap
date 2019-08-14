//
//  LocationsViewModel.swift
//  On the Map
//
//  Created by Zhazira Garipolla on 8/14/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import Foundation

protocol LocationsViewModelDelegate: class {
    func reloadData()
}

class LocationsViewModel {
    var locations: [StudentLocation] = [] {
        didSet {
            delegate?.reloadData()
        }
    }
    let networkManager = NetworkManager()
    let requestProvider = RequestProvider()
    weak var delegate: LocationsViewModelDelegate?
    
    init() {
        fetchLocations()
    }
    
    func fetchLocations() {
        let request = requestProvider.getStudentLocations()
        networkManager.makeRequest(request, responseType: StudentsLocationsResponse.self, isSkippingChars: false) { [weak self] result in
            switch result {
            case .success(let response):
                self?.locations = response.results
//                print(self?.locations.count)
//                self?.delegate?.reloadData()
            case .failure(let error):
                print(error)
                break
                // TODO: delegate VC to show alert
            }
            
        }
    }
}
