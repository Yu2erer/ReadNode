//
//  RNFeedDetailsViewController.swift
//  ReadNode
//
//  Created by ntian on 2017/8/18.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit
import SVProgressHUD

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
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        SVProgressHUD.dismiss()
    }


}
// MARK: - UIWebViewDelegate
extension RNFeedDetailsViewController: UIWebViewDelegate {
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
}
// MARK: - UIScrollViewDelegate
extension RNFeedDetailsViewController {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y > 0 {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            webView.scrollView.contentInset.bottom = 0
            webView.scrollView.scrollIndicatorInsets = webView.scrollView.contentInset
        } else {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            webView.scrollView.contentInset.bottom = (navigationController?.navigationBar.bounds.height ?? 44) + 20
            webView.scrollView.scrollIndicatorInsets = webView.scrollView.contentInset
        }

    }
}
// MARK: - UI
extension RNFeedDetailsViewController {
    fileprivate func setupUI() {
        let statusBar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.nt_screenWidth, height: 20))
        statusBar.backgroundColor = UIColor.white
        navigationController?.view.insertSubview(statusBar, at: 1)
        navigationItem.titleView = UILabel.titleView(text: "ReadNode", textColor: UIColor.nt_color(hex: 0x34394B), font: UIFont(name: "PingFang", size: 12))
        view.addSubview(webView)
        webView.backgroundColor = UIColor.white
        webView.delegate = self
        webView.scrollView.contentInset.bottom = (navigationController?.navigationBar.bounds.height ?? 44) + 20
        webView.scrollView.scrollIndicatorInsets = webView.scrollView.contentInset
        webView.scrollView.delegate = self
        
    }
    override func setupTableView() { }
}
