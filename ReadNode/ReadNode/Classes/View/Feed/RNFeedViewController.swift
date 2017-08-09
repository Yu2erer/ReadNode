//
//  RNFeedViewController.swift
//  ReadNode
//
//  Created by ntian on 2017/8/9.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit

class RNFeedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    @objc fileprivate func test() {
        let vc = RNDemoViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

}
// MARK: - UI
extension RNFeedViewController {
    fileprivate func setupUI() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Test", style: .plain, target: self, action: #selector(test))
        view.backgroundColor = UIColor.white
    }
}
