//
//  MapViewController.swift
//  On the Map
//
//  Created by Zhazira Garipolla on 8/14/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import UIKit
import MapKit

protocol MapViewControllerDelegate: class {
    func updateExitingLocation()
    func postNewLocation()
}

class MapViewController: UIViewController, MKMapViewDelegate {
   
    let mapView = MKMapView(frame: .zero)
    weak var delegate: MapViewControllerDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        LocationsViewModel.shared.fetchLocations()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        LocationsViewModel.shared.fetcherDelegate = self
        LocationsViewModel.shared.errorDelegate = self
//        LocationsViewModel.shared.fetchLocations()
        
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
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @objc func didTapAddButton(_ sender: UIBarButtonItem) {
        self.present(UINavigationController(rootViewController: PostLocationViewController()), animated: true)
    }
    
    func updateExistingLocatoin () {
        
    }
    
    @objc func didTapLogoutButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
        LocationsViewModel.shared.deleteSession()
    }
    
    @objc func didTapReloadButton(_ sender: UIBarButtonItem) {
        LocationsViewModel.shared.fetchLocations()
    }
    
    
    func setupPins() {
        let locations = LocationsViewModel.shared.locations
        var annotations = [MKPointAnnotation]()

        for item in locations {
            let lat = CLLocationDegrees(Double(item.latitude))
            let long = CLLocationDegrees(Double(item.longitude))
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
           
            let first = item.firstName
            let last = item.lastName
            let mediaURL = item.mapString
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL

            annotations.append(annotation)
        }

        self.mapView.addAnnotations(annotations)
        
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
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
            }
        }
    }
}

extension MapViewController: LocationsFetcherDelegate, ErrorHandlerDelegate {
    func showError(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func fetchedSuccessfully() {
        setupPins()
    }
}


