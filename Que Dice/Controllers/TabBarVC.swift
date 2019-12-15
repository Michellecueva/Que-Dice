//
//  TabBarVC.swift
//  Que Dice
//
//  Created by Michelle Cueva on 12/14/19.
//  Copyright © 2019 Michelle Cueva. All rights reserved.
//

import UIKit

class TabBarVC: UITabBarController {
    
    lazy var cameraVC = CameraViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraVC.tabBarItem = UITabBarItem(title: "Translate", image: UIImage(systemName: "camera"), tag: 0)
        self.viewControllers = [cameraVC]
    }
    
}
