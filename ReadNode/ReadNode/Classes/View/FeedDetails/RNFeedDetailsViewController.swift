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
    
    fileprivate lazy var webView = WKWebView(frame: CGRect(x: 0, y: 0, width: UIScreen.nt_screenWidth, height: UIScreen.nt_screenHeight - 42))
    fileprivate var progressView = UIProgressView(frame: CGRect(x: 0, y: 0, width: UIScreen.nt_screenWidth, height: 30))
    fileprivate let statusBar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.nt_screenWidth, height: 20))
    fileprivate let toolBarView = RNFeedDetailsToolBarView.toolBarView()
    fileprivate let toolBarSettingView = RNFeedDetailsToolBarSettingView.toolBarSettingView()
    /// SettingView是否弹出标记
    fileprivate var settingFlag: Bool = false

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
    fileprivate func showSettingView() {
        let originY: CGFloat = UIScreen.nt_screenHeight - 42 - 60

        if settingFlag {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                self.toolBarSettingView.frame.origin.y = originY + 42 + 20
            }, completion: nil)
            self.settingFlag = false
        } else {
            toolBarSettingView.frame.origin.y = UIScreen.nt_screenHeight + 60 - 42
            UIView.animate(withDuration: 0.3) {
                self.toolBarSettingView.frame.origin.y = originY
            }
            self.settingFlag = true
        }
    }
    fileprivate func changeFontSize(_ segmentStatus: segmentStatus) {
        if segmentStatus == .middle {
            webView.evaluateJavaScript("            document.getElementById('article_title').style.fontSize = 25 + 'px'", completionHandler: nil)
            webView.evaluateJavaScript("            document.getElementById('article_main').style.fontSize = 17 + 'px'", completionHandler: nil)
        } else if segmentStatus == .small {
            webView.evaluateJavaScript("            document.getElementById('article_title').style.fontSize = 21 + 'px'", completionHandler: nil)
            webView.evaluateJavaScript("            document.getElementById('article_main').style.fontSize = 15 + 'px'", completionHandler: nil)
        } else {
            webView.evaluateJavaScript("            document.getElementById('article_title').style.fontSize = 29 + 'px'", completionHandler: nil)
            webView.evaluateJavaScript("            document.getElementById('article_main').style.fontSize = 19 + 'px'", completionHandler: nil)
        }
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
            toolBarView.isHidden = true
        } else {
            toolBarView.isHidden = false
        }
    }
}
// MARK: - RNFeedDetailsToolBarDelegate
extension RNFeedDetailsViewController: RNFeedDetailsToolBarDelegate {
    func didClickBack() {
        navigationController?.popViewController(animated: true)
    }
    func didClickLike() {
        if (item?.isLike)! {
            toolBarView.isLike = false
            item?.isLike = false
            RNSQLiteManager.shared.removeLikeFeedItem(item?.itemLink ?? "")
            NTMessageHud.showMessage(message: "Uncollected")
        } else {
            toolBarView.isLike = true
            item?.isLike = true
            RNSQLiteManager.shared.addLikeFeedItem(item!)
            NTMessageHud.showMessage(message: "Collected")
        }
    }
    func didClickMore() {
        showSettingView()
    }
}
// MARK: - RNFeedDetailsToolBarSettingViewDelegate
extension RNFeedDetailsViewController: RNFeedDetailsToolBarSettingViewDelegate {
    func didChangeFontSize(_ segmentStatus: segmentStatus) {
        fontSize = segmentStatus.rawValue
        UserDefaults.standard.set(segmentStatus.rawValue, forKey: "fontSize")
        changeFontSize(segmentStatus)
    }
}
// MARK: - WKNavigationDelegate
extension RNFeedDetailsViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        changeFontSize(segmentStatus(rawValue: fontSize)!)
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
        webView.scrollView.scrollIndicatorInsets =
            webView.scrollView.contentInset
        webView.navigationDelegate = self
        toolBarView.translatesAutoresizingMaskIntoConstraints = false
        toolBarView.toolBarDelegate = self
        toolBarView.isLike = item?.isLike
        view.addSubview(toolBarSettingView)
        view.addSubview(toolBarView)
        view.addConstraint(NSLayoutConstraint(item: toolBarView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: toolBarView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: toolBarView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: view.bounds.width))
        view.addConstraint(NSLayoutConstraint(item: toolBarView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 42))
        toolBarSettingView.frame = CGRect(x: 0, y: UIScreen.nt_screenHeight + 60 - 42, width: view.bounds.width, height: 60)
        toolBarSettingView.segmentIndex = segmentStatus(rawValue: fontSize)!
        toolBarSettingView.settingViewDelegate = self
//        webView.scrollView.delegate = self
    }
    override func setupTableView() { }
}
