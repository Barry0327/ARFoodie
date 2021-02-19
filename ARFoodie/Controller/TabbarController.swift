//
//  TabbarController.swift
//  ARFoodie
//
//  Created by Chen Yi-Wei on 2019/4/14.
//  Copyright © 2019 Chen Yi-Wei. All rights reserved.
//

import UIKit
import ChameleonFramework

class TabbarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.tintColor = UIColor.flatWatermelonDark()

        if let tabBarItems = tabBar.items {

            tabBarItems[0].image = UIImage(named: "location-template")

            tabBarItems[0].title = nil

            tabBarItems[0].imageInsets = UIEdgeInsets(top: 9, left: 0, bottom: -9, right: 0)

            tabBarItems[1].image = UIImage(named: "user-small")

            tabBarItems[1].title = nil

            tabBarItems[1].imageInsets = UIEdgeInsets(top: 9, left: 0, bottom: -9, right: 0)

        }

    }
}
