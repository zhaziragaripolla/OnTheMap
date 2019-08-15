//
//  PostLocationViewController.swift
//  On the Map
//
//  Created by Zhazira Garipolla on 8/14/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class PostLocationViewController: UIViewController, MKMapViewDelegate {
    
    let mapView = MKMapView(frame: .zero)
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
        button.backgroundColor = .clear
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        return button
    }()
    
    lazy var finishButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Finish", for: .normal)
        button.backgroundColor = UIColor.lightBlue
        button.layer.cornerRadius = 30
//        button.layer.borderWidth = 1
//        button.layer.borderColor = UIColor.black.cgColor
        return button
    }()
    
    lazy var resultLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightBlue
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.backgroundColor = .clear
        return label
    }()
    
    var geocodoer = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        self.tabBarController?.tabBar.isHidden = true
        
        findButton.addTarget(self, action: #selector(didTapFindButton(_:)), for: .touchUpInside)
        finishButton.addTarget(self, action: #selector(didTapFinishButton(_:)), for: .touchUpInside)
        
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
        
        
        setupMapView()
    }
    
    fileprivate func setupMapView() {
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
        mapView.isHidden = true
        mapView.delegate = self
        
        mapView.addSubview(finishButton)
        finishButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            finishButton.widthAnchor.constraint(equalToConstant: 60),
            finishButton.heightAnchor.constraint(equalToConstant: 60),
            finishButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: -15),
            finishButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15)
            ])
        finishButton.isHidden = true
        
        
        mapView.addSubview(resultLabel)
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            resultLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            resultLabel.heightAnchor.constraint(equalToConstant: 60),
            resultLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            resultLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15)
            ])
        
        resultLabel.isHidden = true
    }
    
    @objc func didTapFindButton(_ sender: UIButton) {
        if locationTextField.text!.isEmpty, linkTextField.text!.isEmpty {
            
        }
        else {
            geocodoer.geocodeAddressString(locationTextField.text!, in: nil) { [weak self] placemark, error in
                guard let placemark = placemark else { return }
                
                if ((self?.latitude = placemark[0].location?.coordinate.latitude) != nil),
                    ((self?.longtitude = placemark[0].location?.coordinate.longitude) != nil) {
                    self?.showOnTheMap(latitude: self?.latitude ?? 0, longtitude: self?.longtitude ?? 0)
                }
               
                
                else {
                    let alertController = UIAlertController(title: "New location", message: "Not found", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(action)
                    self?.present(alertController, animated: true, completion: nil)

                }
               
            }
        }
    }
    
    @objc func didTapFinishButton(_ sender: UIButton) {
        // TODO: save new location to view model
        LocationsViewModel.shared.postNewLocation(location: locationTextField.text!, mediaURL: linkTextField.text!, latitude: Float(latitude!), longtitude: Float(longtitude!))
    }
    
    func showOnTheMap(latitude: CLLocationDegrees, longtitude: CLLocationDegrees) {
        mapView.isHidden = false
        finishButton.isHidden = false
        resultLabel.isHidden = false
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
//        annotation.subtitle = mediaURL
        mapView.addAnnotation(annotation)
        resultLabel.text = annotation.description
        mapView.setCenter(coordinate, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
  
}
