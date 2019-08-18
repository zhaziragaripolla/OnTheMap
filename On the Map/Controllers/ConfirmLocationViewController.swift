//
//  ShowNewLocationViewController.swift
//  On the Map
//
//  Created by Zhazira Garipolla on 8/16/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import UIKit
import MapKit

class ConfirmLocationViewController: UIViewController {

    let mapView = MKMapView(frame: .zero)
    var locationCoordinate: CLLocationCoordinate2D!
    var mediaUrl: String!
    var locationName: String!
    
    lazy var finishButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Finish", for: .normal)
        button.backgroundColor = .lightBlue
        button.layer.cornerRadius = 30
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Add location"
        view.backgroundColor = .white
        LocationsViewModel.shared.taskDelegate = self
        
        finishButton.addTarget(self, action: #selector(didTapFinishButton(_:)), for: .touchUpInside)
        
        setupMapView()
        showOnTheMap()
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
            finishButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            finishButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15)
            ])
        
    }
    
    private func showOnTheMap() {
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationCoordinate
        annotation.subtitle = mediaUrl
        mapView.addAnnotation(annotation)
        
        let viewRegion = MKCoordinateRegion(center: locationCoordinate, latitudinalMeters: 10_000, longitudinalMeters: 10_000)
        mapView.setRegion(viewRegion, animated: false)
    }
    
    
    @objc func didTapFinishButton(_ sender: UIButton) {
        LoadingOverlay.shared.showOverlay(view: view)
        LocationsViewModel.shared.setNewLocation(location: locationName, mediaURL: mediaUrl, latitude: Float(locationCoordinate.latitude), longitude: Float(locationCoordinate.longitude))
    }
    
}

extension ConfirmLocationViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        pinView.canShowCallout = true
        pinView.pinTintColor = .red
        pinView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        pinView.annotation = annotation
        return pinView
    }
}

extension ConfirmLocationViewController: NetworkTaskCompletionDelegate{
    func taskCompleted() {
        LoadingOverlay.shared.hideOverlayView()
        dismiss(animated: true, completion: nil)
    }
    
    func showError(message: String) {
        LoadingOverlay.shared.hideOverlayView()
        let alertController = UIAlertController(title: "Posting new location is failed", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
}
