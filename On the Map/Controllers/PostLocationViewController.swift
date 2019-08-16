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
        textField.text = "Astana"
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 5
        return textField
    }()
    
    lazy var linkTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.text = "google.com"
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 5
        return textField
    }()
    
    lazy var findButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Find", for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        return button
    }()
    
    var geocodoer = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightBlue
//        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancelButton(_:)))
        findButton.addTarget(self, action: #selector(didTapFindButton(_:)), for: .touchUpInside)
        
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
            stackView.heightAnchor.constraint(equalToConstant: 90)
            ])
    }
    
    @objc func didTapFindButton(_ sender: UIButton) {
        
        guard let location = locationTextField.text, let link = linkTextField.text else {
            let alertController = UIAlertController(title: "New location", message: "Please fill in new location or link", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        LoadingOverlay.shared.showOverlay(view: view)
        
        findNewLocation(location) { success in
            if success {
                let vc = ShowNewLocationViewController()
                vc.locationCoordinate = CLLocationCoordinate2D(latitude: self.latitude!, longitude: self.longtitude!)
                vc.mediaUrl = link
                vc.locationName = location
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
        
    }
    
    @objc func didTapCancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    func findNewLocation(_ location: String, completion: @escaping (Bool)->()) {
        
        geocodoer.geocodeAddressString(location, in: nil) { [weak self] placemarks, error in
            if let foundLocation = placemarks?.first?.location {
                self?.latitude = foundLocation.coordinate.latitude
                self?.longtitude = foundLocation.coordinate.longitude
                DispatchQueue.main.async {
                    LoadingOverlay.shared.hideOverlayView()
                    completion(true)
                }
                
            }
            
            if let error = error as? CLError {
                
                let errorType = error.errorCode == CLError.Code.geocodeFoundNoResult.rawValue ? "Not found" : "Error: \(error.code)"
                
                let alertController = UIAlertController(title: "New location", message: errorType, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self?.present(alertController, animated: true, completion: nil)
                DispatchQueue.main.async {
                    LoadingOverlay.shared.hideOverlayView()
                    completion(false)
                }
            }
            
        }
        
    }
    
//    func verifyUrl(_ link: String)-> Bool {
//        if let url = URL(string: link) {
//            return UIApplication.shared.canOpenURL(url)
//        }
//        return false
//    }


}
