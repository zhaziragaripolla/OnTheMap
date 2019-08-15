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

protocol SessionCompletionDelegate: class {
    func createdSuccessfully()
//    func showError(message: String)
}


protocol LocationsFetcherDelegate: class {
    func fetchedSuccessfully()
}

protocol ErrorHandlerDelegate: class {
    func showError(message: String)
}

class LocationsViewModel {
    
    static let shared = LocationsViewModel()
    var locations: [StudentLocation] = [] {
        didSet {
            delegate?.reloadData()
        }
    }
//    var user: User?
    let networkManager = NetworkManager()
    let requestProvider = RequestProvider()
    
    weak var delegate: LocationsViewModelDelegate?
    weak var sessionDelegate: SessionCompletionDelegate?
    weak var errorDelegate: ErrorHandlerDelegate?
    weak var fetcherDelegate: LocationsFetcherDelegate?
    
    private init() {
//        fetchLocations()
//        getUserData()
    }
    
    func createSession() {
        let request = requestProvider.createSession(login: "zhumabayeva97@gmail.com", password: "Tools003")
        networkManager.makeRequest(request, responseType: UdacityResponse.self, isSkippingChars: true, callback: {[weak self] result in
            switch result {
            case .success(let response):
                Auth.accountKey = response.account.key
                Auth.sessdionId = response.session.id
                print(Auth.accountKey)
                self?.sessionDelegate?.createdSuccessfully()
            case .failure(let error):
                self?.errorDelegate?.showError(message: error.localizedDescription)
                break
            }
            
        })
    }
    
    func fetchLocations() {
        let request = requestProvider.getStudentLocations()
        networkManager.makeRequest(request, responseType: StudentsLocationsResponse.self, isSkippingChars: false) { [weak self] result in
            switch result {
            case .success(let response):
                self?.locations = response.results
                self?.fetcherDelegate?.fetchedSuccessfully()
            case .failure(let error):
                print(error)
                break
                // TODO: delegate VC to show alert
            }
            
        }
    }
    
    func getUserData() {
        let request = requestProvider.getUserData()

        networkManager.makeRequest(request, responseType: UserResponse.self, isSkippingChars: true) { result in
            switch result {
            case .success(let response):
                User.firstName = response.firstName
                User.lastName = response.lastName
                User.location = response.location
                print(User.firstName, User.lastName, User.location)
            case .failure(let error):
                
                print("user unfetched", error)
                break
                // TODO: delegate VC to show alert
            }
            
        }
    }
    
    func postNewLocation(location: String, mediaURL: String, latitude: Float, longtitude: Float) {
        let request = requestProvider.postStudentLocation(location: location, mediaURL: mediaURL, latitude: latitude, longitude: longtitude)

        networkManager.makeRequest(request, responseType: PostStudentLocationResponse.self, isSkippingChars: false) { result in
            switch result {
            case .success(let response):
                print("New location is posted")
             
            case .failure(let error):
                print("New location posting is unsuccessfull", error)
                break
                // TODO: delegate VC to show alert
            }
            
        }
    }
    
    func deleteSession() {
        
    }
}
