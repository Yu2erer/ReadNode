//
//  RNFeedDetailsViewController.swift
//  ReadNode
//
//  Created by ntian on 2017/8/18.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit

class RNFeedDetailsViewController: RNBaseViewController {
    
    fileprivate lazy var webView = UIWebView(frame: UIScreen.main.bounds)
    
    var item: RNRssFeedItem? {
        didSet {
            guard let item = item, let urlString = item.link, let url = URL(string: urlString) else {
                return
            }
            webView.loadRequest(URLRequest(url: url))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }


}
// MARK: - UI
extension RNFeedDetailsViewController {
    fileprivate func setupUI() {
        view.addSubview(webView)
        webView.backgroundColor = UIColor.white
        webView.scrollView.contentInset.bottom = (navigationController?.navigationBar.bounds.height ?? 44) + 20
        webView.scrollView.scrollIndicatorInsets = webView.scrollView.contentInset
        
    }
    override func setupTableView() { }
}
