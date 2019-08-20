//
//  PostLocationViewController.swift
//  On the Map
//
//  Created by Zhazira Garipolla on 8/14/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import UIKit
import CoreLocation

class PostLocationViewController: UIViewController {
 
    var latitude: CLLocationDegrees?
    var longtitude: CLLocationDegrees?
    
    var locationTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.placeholder = "Enter a location"
        textField.text = "New York"
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 5
        return textField
    }()
    
    lazy var linkTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.placeholder = "Enter a website"
        textField.text = "https://google.com"
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 5
        return textField
    }()
    
    lazy var findButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Find", for: .normal)
        button.backgroundColor = .lightBlue
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        return button
    }()
    
    let geocodoer = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "New location"
        
        setupView()
    }
    
    fileprivate func setupView() {
        view.backgroundColor = .white
        
        // Configuring buttons
        findButton.addTarget(self, action: #selector(didTapFindButton(_:)), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancelButton(_:)))
        
        let stackView = UIStackView(arrangedSubviews: [locationTextField, linkTextField, findButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 5
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            stackView.heightAnchor.constraint(equalToConstant: 120)
            ])
    }
    
    // MARK: Find Button
    @objc func didTapFindButton(_ sender: UIButton) {
        guard let location = locationTextField.text, let link = linkTextField.text else {
            let alertController = UIAlertController(title: "New location", message: "Please fill in new location or link", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alertController, animated: true, completion: nil)
            return
        }
        
        LoadingOverlay.shared.showOverlay(view: view)
        
        findNewLocation(location) { [weak self] result in
            if let newLocation = result?.location {
                let vc = ConfirmLocationViewController()
                vc.locationCoordinate = CLLocationCoordinate2D(latitude: newLocation.coordinate.latitude, longitude: newLocation.coordinate.longitude)
                vc.locationName = result?.locality
                vc.mediaUrl = link
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
    
    @objc func didTapCancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // helper to forward-geocode a location
    private func findNewLocation(_ location: String, completion: @escaping (CLPlacemark?)->()) {
        geocodoer.geocodeAddressString(location, in: nil) { [weak self] placemarks, error in
            if let foundLocation = placemarks?.first{
                DispatchQueue.main.async {
                    LoadingOverlay.shared.hideOverlayView()
                    completion(foundLocation)
                }
            }
            
            if let error = error as? CLError {
                let errorType = error.errorCode == CLError.Code.geocodeFoundNoResult.rawValue ? "Not found" : "Error: \(error.code)"
                let alertController = UIAlertController(title: "Error", message: errorType, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self?.present(alertController, animated: true, completion: nil)
                DispatchQueue.main.async {
                    LoadingOverlay.shared.hideOverlayView()
                    completion(nil)
                }
            }
        }
    }
    
}
