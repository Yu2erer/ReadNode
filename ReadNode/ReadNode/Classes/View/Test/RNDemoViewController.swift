//
//  RNDemoViewController.swift
//  ReadNode
//
//  Created by ntian on 2017/8/9.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit
import CloudKit

class RNDemoViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        RNCloudKitManager.shared.delete(recordName: "ReadNode") { (isSuccess) in
            print(isSuccess)
        }
        RNCloudKitManager.shared.delete(recordName: "LikeReadNode") { (isSuccess) in
            print(isSuccess)
        }
    }
}
