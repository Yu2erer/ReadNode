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
    @objc fileprivate func add(_ sender: UIButton) {
        let btnAnime = CAKeyframeAnimation(keyPath: "transform.scale")
        btnAnime.values = [1.0,0.7,0.5,0.3,0.5,0.7,1.0,1.2,1.4,1.2,1.0]
        btnAnime.keyTimes = [0.0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0]
        btnAnime.duration = 0.3
        sender.layer.add(btnAnime, forKey: "SHOW")
        
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
        addBtn.addTarget(self, action: #selector(add), for: .touchUpInside)
        view.addSubview(addBtn)
    }
}
