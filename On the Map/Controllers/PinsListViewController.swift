//
//  PinsListViewController.swift
//  On the Map
//
//  Created by Zhazira Garipolla on 8/14/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import UIKit

class PinsListViewController: UIViewController, LocationsViewModelDelegate {
    func reloadData() {
        
        tableView.reloadData()
        
    }
    
    let tableView = UITableView(frame: .zero)
    var viewModel: LocationsViewModel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.delegate = self
        view.backgroundColor = .white
        title = "Pins"
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
        
        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddButton(_:)))
        let reloadItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: nil)
        let logoutItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: nil)
        navigationItem.leftBarButtonItems = [logoutItem]
        navigationItem.rightBarButtonItems = [addItem, reloadItem]
    }
    
    @objc func didTapAddButton(_ sender: UIBarButtonItem) {
        
    }
    

}

extension PinsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let location = viewModel.locations[indexPath.row]
        cell.textLabel?.text = "\(location.firstName.description) \(location.lastName.description)"
        return cell
    }
}
