//
//  RNDiscoverViewController.swift
//  ReadNode
//
//  Created by ntian on 2017/8/9.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit
import Popover
import SVProgressHUD

class RNDiscoverViewController: UIViewController {

    fileprivate lazy var popover = Popover()
    fileprivate lazy var addView: RNAddView = Bundle.main.loadNibNamed("RNAddView", owner: nil, options: nil)?.last as! RNAddView

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    @objc fileprivate func add(_ sender: UIButton) {
        // 放大动画
        let btnAnime = CAKeyframeAnimation(keyPath: "transform.scale")
        btnAnime.values = [1.0,0.7,0.5,0.3,0.5,0.7,1.0,1.2,1.4,1.2,1.0]
        btnAnime.keyTimes = [0.0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0]
        btnAnime.duration = 0.2
        sender.layer.add(btnAnime, forKey: "SHOW")
        addView.frame = CGRect(x: 0, y: 0, width: UIScreen.nt_screenWidth - 20, height: 200)
        
        popover.show(addView, point: CGPoint(x: view.bounds.width / 2, y: 74))
    }
}
// MARK: - RNAddViewDelegate
extension RNDiscoverViewController: RNAddViewDelegate {
    func didClickClose() {
        popover.dismiss()
    }
    func didClickSave(urlString: String) {
        popover.dismiss()
        SVProgressHUD.show()
        RNNetworkManager.shared.request(urlString: urlString) { (rssFeed, isSuccess) in
            SVProgressHUD.dismiss()
            if !isSuccess {
                NTMessageHud.showMessage(message: "No sources found.Please enter a valid site url")
                return
            }
            NTMessageHud.showMessage(message: rssFeed?.title)
        }
    }
}
// MARK: - UI
extension RNDiscoverViewController {
    fileprivate func setupUI() {
        navigationItem.titleView = UILabel.titleView(text: "Discover", textColor: UIColor.nt_color(hex: 0x34394B), font: UIFont(name: "PingFang", size: 12))
        // addBtn
        let addBtn = UIButton(type: .custom)
        addBtn.frame = CGRect(x: view.bounds.width - 12 - 72, y: view.bounds.height - 12 - 64 - 49 - 72, width: 72, height: 72)
        addBtn.setImage(UIImage(named: "addButton"), for: .normal)
        addBtn.addTarget(self, action: #selector(add), for: .touchUpInside)
        view.addSubview(addBtn)
        // popover
        let popoverOptions: [PopoverOption] = [
            .type(.down),
            .arrowSize(CGSize(width: 0.1, height: 0.1)),
            .cornerRadius(10.0),
            .blackOverlayColor(UIColor(white: 0.0, alpha: 0.4))
        ]
        popover = Popover(options: popoverOptions)
        popover.dismissOnBlackOverlayTap = false
        addView.frame = CGRect(x: 0, y: 0, width: UIScreen.nt_screenWidth - 20, height: 200)
        addView.viewDelegate = self
    }
}
