//
//  RNFeedDetailsViewController.swift
//  ReadNode
//
//  Created by ntian on 2017/8/18.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit
import WebKit

class RNFeedDetailsViewController: RNBaseViewController {
    
    fileprivate lazy var webView = WKWebView(frame: UIScreen.main.bounds)
    fileprivate var progressView = UIProgressView(frame: CGRect(x: 0, y: 0, width: UIScreen.nt_screenWidth, height: 30))
    fileprivate let statusBar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.nt_screenWidth, height: 20))
    fileprivate let toolBarView = RNFeedDetailsToolBarView.toolBarView()
    
    var item: RNRssFeedItem? {
        didSet {
            guard let item = item, let link = item.link, let url = URL(string: link) else {
                return
            }
            webView.loadHTMLString(prepareHtml(item) ?? "", baseURL:             item.imagesFromDescription! == [] ? url : nil)
        }
    }
    fileprivate func prepareHtml(_ item: RNRssFeedItem) -> String? {
        guard let htmlPath = Bundle.main.path(forResource: "template", ofType: "html") else {
            return nil
        }
        var htmlContent = try? String(contentsOfFile: htmlPath)
        var range = htmlContent?.range(of: "{$title}")
        htmlContent?.replaceSubrange(range!, with: item.title ?? "")
        range = htmlContent?.range(of: "{$author}")
        htmlContent?.replaceSubrange(range!, with: item.author ?? "")
        range = htmlContent?.range(of: "{$pubDate}")
        htmlContent?.replaceSubrange(range!, with: item.pubDate?.nt_dateDescription ?? "")
        range = htmlContent?.range(of: "{$content}")
        htmlContent?.replaceSubrange(range!, with: item.itemDescription ?? "")
        return htmlContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }
    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress", context: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        progressView.removeFromSuperview()
        statusBar.removeFromSuperview()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            self.progressView.alpha = 1.0
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
            if progressView.progress >= 1.0 {
                UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut, animations: { 
                    self.progressView.alpha = 0.0
                }, completion: { (_) in
                    self.progressView.progress = 0.0
                })
            }
        }
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
// MARK: - RNFeedDetailsToolBarDelegate
extension RNFeedDetailsViewController: RNFeedDetailsToolBarDelegate {
    func didClickBack() {
        navigationController?.popViewController(animated: true)
    }
}
// MARK: - UI
extension RNFeedDetailsViewController {
    fileprivate func setupUI() {
        statusBar.backgroundColor = UIColor.white
        navigationController?.view.insertSubview(statusBar, at: 1)
        navigationItem.titleView = UILabel.nt_label(text: "ReadNode", textColor: UIColor.nt_color(hex: 0x34394B), font: UIFont(name: "PingFang", size: 12))
    
        view.addSubview(webView)
        statusBar.addSubview(progressView)
        progressView.progress = 0.1
        progressView.backgroundColor = UIColor.white
        progressView.trackTintColor = UIColor.white
        progressView.tintColor = UIColor.nt_color(hex: 0xFFB1E9)
        webView.backgroundColor = UIColor.white
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.contentInset.bottom = 0
        webView.scrollView.scrollIndicatorInsets = webView.scrollView.contentInset
        toolBarView.translatesAutoresizingMaskIntoConstraints = false
        toolBarView.toolBarDelegate = self
        view.addSubview(toolBarView)
        view.addConstraint(NSLayoutConstraint(item: toolBarView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: toolBarView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: toolBarView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: view.bounds.width))
        view.addConstraint(NSLayoutConstraint(item: toolBarView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 42))
//        webView.scrollView.delegate = self
        
    }
    override func setupTableView() { }
}
