//
//  ViewController.swift
//  d07
//
//  Created by Suliac LE-GUILLOU on 4/4/18.
//  Copyright © 2018 Suliac LE-GUILLOU. All rights reserved.
//

import UIKit

class MainController: UITabBarController {
    
    let recastController:UINavigationController = {
        let root = RecastController()
        let controller = UINavigationController(rootViewController: root)
        
        controller.tabBarItem.title = "Recast"
        controller.tabBarItem.image = UIImage(named: "spot")
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = UIColor(white: CGFloat(0.99), alpha: CGFloat(1.0))
        
        viewControllers = [recastController]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

