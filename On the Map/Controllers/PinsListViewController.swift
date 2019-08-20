//
//  PinsListViewController.swift
//  On the Map
//
//  Created by Zhazira Garipolla on 8/14/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import UIKit

class PinsListViewController: UIViewController {
  
    let tableView = UITableView(frame: .zero)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LocationsViewModel.shared.fetchLocations()
        LoadingOverlay.shared.showOverlay(view: self.view)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Pins"

        LocationsViewModel.shared.errorDelegate = self
        LocationsViewModel.shared.reloadDelegate = self
        
        setupTableView()
        setupBarItems()
    }
    
    fileprivate func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            ])
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PinTableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    fileprivate func setupBarItems() {
        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddButton(_:)))
        let reloadItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(didTapReloadButton(_:)))
        let logoutItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(didTapLogoutButton(_:)))
        navigationItem.leftBarButtonItems = [logoutItem]
        navigationItem.rightBarButtonItems = [addItem, reloadItem]
    }
    
    @objc func didTapAddButton(_ sender: UIBarButtonItem) {
       present(UINavigationController(rootViewController: PostLocationViewController()), animated: true)
    }
    
    @objc func didTapReloadButton(_ sender: UIBarButtonItem) {
        LoadingOverlay.shared.showOverlay(view: view)
        LocationsViewModel.shared.fetchLocations()
    }
    
    // MARK: Logout Button
    @objc func didTapLogoutButton(_ sender: UIBarButtonItem) {
        LocationsViewModel.shared.deleteSession()
        dismiss(animated: true, completion: nil)
    }

}

extension PinsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LocationsViewModel.shared.locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PinTableViewCell
        let location = LocationsViewModel.shared.locations[indexPath.row]
        cell.titleLabel.text = "\(location.firstName.description) \(location.lastName.description)"
        cell.detailLabel.text = location.mediaURL
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    // MARK: Tap a row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = LocationsViewModel.shared.locations[indexPath.row]
        if location.mediaURL.isValidURL() {
            UIApplication.shared.open(URL(string: location.mediaURL)!, options: [:], completionHandler: nil)
        }
        else {
            let alertController = UIAlertController(title: "Invalid link", message: "Cannot open url.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(action)
            present(alertController, animated: true, completion: nil)
        }
    }
}

extension PinsListViewController: UpdateDataDelegate, ErrorPresenterDelegate {
    
    func reload() {
        tableView.reloadData()
        LoadingOverlay.shared.hideOverlayView()
    }
    
    func showError(message: String) {
        LoadingOverlay.shared.hideOverlayView()
        let alertController = UIAlertController(title: "Failed to show student locations", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    
}




