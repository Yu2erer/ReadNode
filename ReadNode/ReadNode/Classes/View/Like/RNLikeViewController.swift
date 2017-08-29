//
//  RNLikeViewController.swift
//  ReadNode
//
//  Created by ntian on 2017/8/9.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit

class RNLikeViewController: RNBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    override func setupTableView() {
        
    }


}
// MARK: - UI
extension RNLikeViewController {
    fileprivate func setupUI() {
        navigationItem.titleView = UILabel.titleView(text: "Favourites", textColor: UIColor.nt_color(hex: 0x34394B), font: UIFont(name: "PingFang", size: 12))
    }
}
