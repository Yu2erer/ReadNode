//
//  AppDelegate.swift
//  ReadNode
//
//  Created by ntian on 2017/8/8.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit
import Bugly
import SVProgressHUD

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
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
       
        let urlString = url.absoluteString.replacingOccurrences(of: "feed:", with: "")
        SVProgressHUD.show()
        RNNetworkManager.shared.request(urlString: urlString) { (rssFeed, isSuccess) in
            SVProgressHUD.dismiss()
            if !isSuccess {
                NTMessageHud.showMessage(message: "No sources found.Please enter a valid site url")
                return
            }
            NTMessageHud.showMessage(message: rssFeed?.title)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: RNAddFeedNotification), object: nil)
        }
        return true
     
    }


}

