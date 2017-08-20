//
//  RNAuthorFeedDetailsViewController.swift
//  ReadNode
//
//  Created by ntian on 2017/8/20.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit

class RNAuthorFeedDetailsViewController: RNBaseViewController {

    var model: RNRssFeed?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

    }
    override func setupTableView() {
        
    }

}
// MARK: - UI
extension RNAuthorFeedDetailsViewController {
    fileprivate func setupUI() {
        view.backgroundColor = UIColor.white
        navigationItem.titleView = RNTitleButton(title: model?.title ?? "", imageUrlString: model?.iconLink)
    }
}
