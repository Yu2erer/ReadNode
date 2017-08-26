//
//  AppDelegate.swift
//  ReadNode
//
//  Created by ntian on 2017/8/8.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit
import Bugly

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow()
        window?.backgroundColor = UIColor.white
        window?.rootViewController = RNMainViewController()
        window?.makeKeyAndVisible()

        #if DEBUG
        #else
            let buglyConfig = BuglyConfig()
            buglyConfig.unexpectedTerminatingDetectionEnable = true
            Bugly.start(withAppId: "48b0becab4", config: buglyConfig)
        #endif
        
        return true
    }


}

