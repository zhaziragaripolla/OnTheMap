//
//  MapViewController.swift
//  On the Map
//
//  Created by Zhazira Garipolla on 8/14/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
   
    let mapView = MKMapView(frame: .zero)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LocationsViewModel.shared.fetchLocations()
        LoadingOverlay.shared.showOverlay(view: view)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        LocationsViewModel.shared.errorDelegate = self
        LocationsViewModel.shared.reloadDelegate = self
        
        setupMapView()
        setupBarItems()
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
    }
    
    fileprivate func setupBarItems() {
        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddButton(_:)))
        let reloadItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(didTapReloadButton(_:)))
        let logoutItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(didTapLogoutButton(_:)))
        navigationItem.leftBarButtonItems = [logoutItem]
        navigationItem.rightBarButtonItems = [addItem, reloadItem]
        tabBarController?.tabBar.isHidden = false
    }
    
    @objc func didTapAddButton(_ sender: UIBarButtonItem) {
        present(UINavigationController(rootViewController: PostLocationViewController()), animated: true)
    }
    
    
    @objc func didTapLogoutButton(_ sender: UIBarButtonItem) {
        LocationsViewModel.shared.deleteSession()
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapReloadButton(_ sender: UIBarButtonItem) {
        LocationsViewModel.shared.fetchLocations()
        LoadingOverlay.shared.showOverlay(view: view)
    }
    
    
    private func setupPins() {
        let locations = LocationsViewModel.shared.locations
        var annotations = [MKPointAnnotation]()

        for item in locations {
            let lat = CLLocationDegrees(Double(item.latitude))
            let long = CLLocationDegrees(Double(item.longitude))
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
           
            let first = item.firstName
            let last = item.lastName
            let mediaURL = item.mediaURL
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            annotations.append(annotation)
        }

        mapView.addAnnotations(annotations)
    }

}

extension MapViewController: MKMapViewDelegate {
    
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
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let urlString = view.annotation?.subtitle!, let url = URL(string: urlString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}

extension MapViewController: UpdateDataDelegate, ErrorPresenterDelegate {
    func reload() {
        LoadingOverlay.shared.hideOverlayView()
        setupPins()
    }
    
    func showError(message: String) {
        LoadingOverlay.shared.hideOverlayView()
        let alertController = UIAlertController(title: "Failed to show student locations", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    
}


