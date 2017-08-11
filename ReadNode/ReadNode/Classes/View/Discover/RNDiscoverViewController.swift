//
//  RNDiscoverViewController.swift
//  ReadNode
//
//  Created by ntian on 2017/8/9.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit

class RNDiscoverViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }



}
// MARK: - UI
extension RNDiscoverViewController {
    fileprivate func setupUI() {
        navigationItem.titleView = UILabel.titleView(text: "Discover", textColor: UIColor.nt_color(hex: 0x34394B), font: UIFont(name: "PingFang", size: 12))
        // addBtn
        let addBtn = UIButton(type: .custom)
        addBtn.frame = CGRect(x: view.bounds.width - 12 - 72, y: view.bounds.height - 12 - 72 - 64 - 49, width: 72, height: 72)
        addBtn.setImage(UIImage(named: "addButton"), for: .normal)
        view.addSubview(addBtn)
    }
}
