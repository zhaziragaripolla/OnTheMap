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
        mapVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "icon-mapview"), tag: 1)
        
        let pinsVC = PinsListViewController()
        pinsVC.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 2)
        pinsVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "icon-listview"), tag: 2)
        
        viewControllers = [mapVC, pinsVC].map { UINavigationController(rootViewController: $0) }
    }
}
