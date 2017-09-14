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
//        let urlString = 
        RNCloudKitManager.shared.save(fileUrlString: rnDBPath, recordName: "ReadNode") { (error) in
//            let err = error as? CKError
            
            print(error)
        }
        RNCloudKitManager.shared.save(fileUrlString: likeDBpath, recordName: "LikeReadNode") { (error) in
            print(error)
        }


    }
}
