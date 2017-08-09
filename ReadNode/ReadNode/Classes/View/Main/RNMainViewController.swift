//
//  RNMainViewController.swift
//  ReadNode
//
//  Created by ntian on 2017/8/8.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit

class RNMainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

}
// MARK: - UI
extension RNMainViewController {
    
    fileprivate func setupUI() {
        setupChildControllers()
    }
    fileprivate func setupChildControllers() {
        
        let array = [["clsName": "RNLikeViewController", "imageName": "tabbar-heart"],
                     ["clsName": "RNDiscoverViewController", "imageName": "tabbar-search"]]
        
        var arrayM = [UIViewController]()
        for dict in array {
            arrayM.append(controller(dict: dict))
        }
        viewControllers = arrayM
    }
    fileprivate func controller(dict: [String: String]) -> UIViewController {
        guard let clsName = dict["clsName"], let imageName = dict["imageName"],         let cls = NSClassFromString(Bundle.namespace + "." + clsName) as? UIViewController.Type else {
            return UIViewController()
        }
        let vc = cls.init()
        vc.tabBarItem.image = UIImage(named: imageName)
        vc.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        let nav = RNNavigationController(rootViewController: vc)
        return nav
    }
}
