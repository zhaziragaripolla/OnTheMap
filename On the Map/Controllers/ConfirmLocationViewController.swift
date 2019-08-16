//
//  ShowNewLocationViewController.swift
//  On the Map
//
//  Created by Zhazira Garipolla on 8/16/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import UIKit
import MapKit

class ConfirmLocationViewController: UIViewController, MKMapViewDelegate {

    let mapView = MKMapView(frame: .zero)
    var locationCoordinate: CLLocationCoordinate2D!
    var mediaUrl: String!
    var locationName: String!
    
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
    
    lazy var finishButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Finish", for: .normal)
        button.backgroundColor = UIColor.lightBlue
        button.layer.cornerRadius = 30
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LocationsViewModel.shared.errorDelegate = self
        LocationsViewModel.shared.posterDelegate = self
        LocationsViewModel.shared.updaterDelegate = self
        
        view.backgroundColor = .white
        finishButton.addTarget(self, action: #selector(didTapFinishButton(_:)), for: .touchUpInside)
        setupMapView()
        showOnTheMap()
        // Do any additional setup after loading the view.
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
        mapView.delegate = self
        
        mapView.addSubview(finishButton)
        finishButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            finishButton.widthAnchor.constraint(equalToConstant: 60),
            finishButton.heightAnchor.constraint(equalToConstant: 60),
            finishButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: -15),
            finishButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15)
            ])
        
        mapView.addSubview(resultLabel)
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        resultLabel.text = locationName
        NSLayoutConstraint.activate([
            resultLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            resultLabel.heightAnchor.constraint(equalToConstant: 60),
            resultLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            resultLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15)
            ])
        
    }
    
    func showOnTheMap() {
        if let coordinate = locationCoordinate {
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.subtitle = mediaUrl
            mapView.addAnnotation(annotation)
            resultLabel.text = annotation.description
            mapView.setCenter(coordinate, animated: true)
        }
        else {
            // TODO: show alert controller
        }
    }
    
    
    @objc func didTapFinishButton(_ sender: UIButton) {
        LoadingOverlay.shared.showOverlay(view: view)
        
        LocationsViewModel.shared.setNewLocation(location: locationName, mediaURL: mediaUrl, latitude: Float(locationCoordinate.latitude), longitude: Float(locationCoordinate.longitude))
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        pinView.canShowCallout = true
        pinView.pinTintColor = .red
        pinView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        pinView.annotation = annotation
        
        return pinView
    }

}

extension ConfirmLocationViewController: LocationPostCompletionDelegate, ErrorHandlerDelegate, LocationUpdateComletionDelegate {
    func putSuccessfully() {
        LoadingOverlay.shared.hideOverlayView()
        dismiss(animated: true, completion: nil)
    }
    
    func postedSuccessfully() {
        LoadingOverlay.shared.hideOverlayView()
        dismiss(animated: true, completion: nil)
    }
    
    func showError(message: String) {
        LoadingOverlay.shared.showOverlay(view: view)
        let alertController = UIAlertController(title: "New location", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
}
