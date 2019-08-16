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
        
        let mapVC = MapViewController()
        mapVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        
        let pinsVC = PinsListViewController()
        pinsVC.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 2)

        LocationsViewModel.shared.getUserData()
        
        
        viewControllers = [mapVC, pinsVC].map { UINavigationController(rootViewController: $0) }
    }
}
