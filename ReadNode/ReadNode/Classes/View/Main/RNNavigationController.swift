//
//  RNNavigationController.swift
//  ReadNode
//
//  Created by ntian on 2017/8/9.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit

class RNNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: - UI
extension RNNavigationController {
    
    fileprivate func setupUI() {
        navigationBar.isTranslucent = false
        // 删除 navigationBar 线 修改背景颜色
        navigationBar.setBackgroundImage(UIImage().imageWithColor(color: UIColor.nt_color(hex: 0xFBFAFB)), for: .default)
        navigationBar.shadowImage = UIImage()
    }

}
