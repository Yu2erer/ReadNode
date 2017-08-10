//
//  RNFeedViewController.swift
//  ReadNode
//
//  Created by ntian on 2017/8/9.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit

class RNFeedViewController: RNBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    override func setupTableView() {
        super.setupTableView()
        
    }

    @objc fileprivate func test() {
        let vc = RNDemoViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

}
// MARK: - UI
extension RNFeedViewController {
    fileprivate func setupUI() {
        navigationItem.title = "ReadNode"
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "tabbar-search", target: self, action: #selector(test))
        view.backgroundColor = UIColor.white
    }
}
