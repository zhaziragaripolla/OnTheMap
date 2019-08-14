//
//  TabBarController.swift
//  On the Map
//
//  Created by Zhazira Garipolla on 8/12/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }
    
    func setupTabs() {
        let viewModel = LocationsViewModel()
        let mapVC = MapViewController()
        mapVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        mapVC.viewModel = viewModel
        let pinsVC = PinsListViewController()
        pinsVC.viewModel = viewModel
        pinsVC.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 2)

        viewControllers = [mapVC, pinsVC].map { UINavigationController(rootViewController: $0) }
    }
}
