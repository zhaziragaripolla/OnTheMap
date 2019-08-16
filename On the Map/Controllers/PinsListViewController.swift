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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        LocationsViewModel.shared.delegate = self
        
        view.backgroundColor = .white
        title = "Pins"
        
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
        navigationController?.pushViewController(PostLocationViewController(), animated: true)
    }
    
    @objc func didTapReloadButton(_ sender: UIBarButtonItem) {
        LocationsViewModel.shared.fetchLocations()
    }
    
    @objc func didTapLogoutButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
        LocationsViewModel.shared.deleteSession()
    }
    

}

extension PinsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LocationsViewModel.shared.locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let location = LocationsViewModel.shared.locations[indexPath.row]
        cell.textLabel?.text = "\(location.firstName.description) \(location.lastName.description)"
        return cell
    }
}

extension PinsListViewController: LocationsViewModelDelegate {
    func reloadData() {
        tableView.reloadData()
    }

    
    func showError(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
}



