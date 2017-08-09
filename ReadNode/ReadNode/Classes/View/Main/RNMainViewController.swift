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
        // 设置 tabbar 背景颜色
        let bgView = UIView(frame: self.tabBar.bounds)
        bgView.backgroundColor = UIColor.nt_color(hex: 0xFBFAFB)
        self.tabBar.insertSubview(bgView, at: 0)
        // 删除 tabbar 的线
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
        // 添加子控制器
        setupChildControllers()
    }
    fileprivate func setupChildControllers() {
        let array = [["clsName": "RNFeedViewController", "imageName": "tabbar-feed"],
                     ["clsName": "RNLikeViewController", "imageName": "tabbar-heart"],
                     ["clsName": "RNDiscoverViewController", "imageName": "tabbar-discover"]]
        
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
