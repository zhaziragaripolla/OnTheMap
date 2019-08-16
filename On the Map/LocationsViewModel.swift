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

protocol NetworkTaskCompletionDelegate: class {
    func taskCompleted()
    func showError(message: String)
}

class LocationsViewModel {
    
    static let shared = LocationsViewModel()
    var locations: [StudentLocation] = [] {
        didSet {
            delegate?.reloadData()
        }
    }
    var existingStudentLocaton: StudentLocation?
    let udacityClient = UdacityClient()
    let parseClient = ParseClient()
    let requestProvider = RequestProvider()
    
    weak var delegate: LocationsViewModelDelegate?
    weak var taskDelegate: NetworkTaskCompletionDelegate?
    
    private init() {}
    
    public func createSession(email: String, password: String) {
        // TODO: change email password
        let request = requestProvider.createSession(login: "zhumabayeva97@gmail.com", password: "Tools003")
        udacityClient.makeRequest(request, responseType: UdacityResponse.self, callback: {[weak self] result in
            switch result {
            case .success(let response):
                Auth.accountKey = response.account.key
                Auth.sessionId = response.session.id
                self?.taskDelegate?.taskCompleted()
            case .failure(let error):
                self?.taskDelegate?.showError(message: error.localizedDescription)
            }
            
        })
    }
    
    public func fetchLocations() {
        let request = requestProvider.getStudentLocations()
        parseClient.makeRequest(request, responseType: StudentsLocationsResponse.self) { [weak self] result in
            switch result {
            case .success(let response):
                self?.locations = response.results
                self?.taskDelegate?.taskCompleted()
            case .failure(let error):
                self?.taskDelegate?.showError(message: error.localizedDescription)
            }
            
        }
    }
    
    public func getUserData() {
        let request = requestProvider.getUserData()

        udacityClient.makeRequest(request, responseType: UserResponse.self) { [weak self] result in
            switch result {
            case .success(let response):
                User.firstName = response.firstName
                User.lastName = response.lastName
                self?.taskDelegate?.taskCompleted()
            case .failure(let error):
                self?.taskDelegate?.showError(message: error.localizedDescription)
            }
            
        }
    }
    
    func setNewLocation(location: String, mediaURL: String, latitude: Float, longitude: Float) {
        
        let newLocationRequest = StudentLocationRequest(firstName: User.firstName, lastName: User.lastName, mapString: location, latitude: latitude, longitude: longitude, mediaURL: mediaURL, uniqueKey: mediaURL)
        
        existingStudentLocaton != nil ? putLocation() : postNewLocation(newLocationRequest)
        
    }
    
    private func postNewLocation(_ location: StudentLocationRequest) {
     
        let request = requestProvider.postStudentLocation(location)
        parseClient.makeRequest(request, responseType: PostStudentLocationResponse.self) { [weak self] result in
            switch result {
            case .success(let response):
                self?.existingStudentLocaton = StudentLocation(firstName: location.firstName, lastName: location.lastName, mapString: location.mapString, latitude: location.latitude, longitude: location.longitude, mediaURL: location.mediaURL, objectId: response.objectId, uniqueKey: location.uniqueKey)
                self?.taskDelegate?.taskCompleted()
            case .failure(let error):
                self?.taskDelegate?.showError(message: error.localizedDescription)
            }
            
        }
    }
    
    private func putLocation() {
        let request = requestProvider.putStudentLocation(existingStudentLocaton!)
        parseClient.makeRequest(request, responseType: PutStudentLocationResponse.self) { [weak self] result in
            switch result {
            case .success:
                self?.taskDelegate?.taskCompleted()
            case .failure(let error):
                self?.taskDelegate?.showError(message: error.localizedDescription)
            }
            
        }
    }
    
    
    func deleteSession() {
        
    }
}
