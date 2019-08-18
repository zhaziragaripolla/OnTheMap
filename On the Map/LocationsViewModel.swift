//
//  LocationsViewModel.swift
//  On the Map
//
//  Created by Zhazira Garipolla on 8/14/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import Foundation

protocol AuthenticationCompletionDelegate: class {
    func completed()
}

protocol NetworkTaskCompletionDelegate: class {
    func taskCompleted()
    func showError(message: String)
}

class LocationsViewModel {
    
    // Singleton class to retrieve data and handle network requests.
    static let shared = LocationsViewModel()
    
    var locations: [StudentLocation] = []
    var existingStudentLocaton: StudentLocation?
    let udacityClient = UdacityClient()
    let parseClient = ParseClient()
    let requestProvider = RequestProvider()
    
    weak var taskDelegate: NetworkTaskCompletionDelegate?
    weak var authenticationDelegate: AuthenticationCompletionDelegate?
    
    private init() {}
    
    // MARK: Create a session
    public func createSession(email: String, password: String) {
    
        let request = requestProvider.createSession(login: email, password: password)
        udacityClient.makeRequest(request, responseType: UdacityResponse.self, callback: {[weak self] result in
            switch result {
            case .success(let response):
                Auth.accountKey = response.account.key
                Auth.sessionId = response.session.id
                self?.authenticationDelegate?.completed()
            case .failure(let error):
                print(error.localizedDescription)
                self?.taskDelegate?.showError(message: error.localizedDescription)
            }
            
        })
    }
    
    // MARK: Fetch Student Locations
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
    
    // MARK: Public User Data
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
    
    // Defines which method (PUT/POST) to call
    func setNewLocation(location: String, mediaURL: String, latitude: Float, longitude: Float) {
        
        let newLocationRequest = StudentLocationRequest(firstName: User.firstName, lastName: User.lastName, mapString: location, latitude: latitude, longitude: longitude, mediaURL: mediaURL, uniqueKey: mediaURL)
        
        // Update existing location or post a new one
        existingStudentLocaton != nil ? putLocation() : postNewLocation(newLocationRequest)
        
    }
    
    // MARK: Post new location
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
    
    // MARK: Update location
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
    
    // MARK: Delete session
    func deleteSession() {
        let request = requestProvider.deleteSession()
        udacityClient.makeRequest(request, responseType: DeleteSessionResponse.self, callback: { result in
            switch result {
            case .success:
                print("Deleted")
            case .failure(let error):
                print("Not deleted", error.localizedDescription)
            }
        })
    }
}
