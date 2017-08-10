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
        // 启用 返回手势
        interactivePopGestureRecognizer?.delegate = self
        interactivePopGestureRecognizer?.isEnabled = true
    }
    // 重写 Push 方法
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if childViewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "nav-back-arrow", target: self, action: #selector(popToParent))
        }
        super.pushViewController(viewController, animated: animated)
    }
    /// POP 返回到上一级 控制器
    @objc fileprivate func popToParent() {
        popViewController(animated: true)
    }
}
// MARK: - 侧滑手势
extension RNNavigationController: UIGestureRecognizerDelegate {

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return childViewControllers.count > 1
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
