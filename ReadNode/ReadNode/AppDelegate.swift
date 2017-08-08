//
//  AppDelegate.swift
//  ReadNode
//
//  Created by ntian on 2017/8/8.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow()
        window?.backgroundColor = UIColor.white
        window?.rootViewController = RNMainViewController()
        window?.makeKeyAndVisible()
        
        return true
    }


}

