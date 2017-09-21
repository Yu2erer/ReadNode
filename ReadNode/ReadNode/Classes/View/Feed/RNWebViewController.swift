//
//  RNWebViewController.swift
//  ReadNode
//
//  Created by ntian on 2017/8/26.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit
import SVProgressHUD

class RNWebViewController: RNBaseViewController {
    
    private lazy var webView = UIWebView(frame: UIScreen.main.bounds)

    var urlString: String? {
        didSet {
            guard let urlString = urlString, let url = URL(string: urlString) else {
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
        SVProgressHUD.dismiss()
    }

}
// MARK: - UIWebViewDelegate
extension RNWebViewController: UIWebViewDelegate {
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
        navigationItem.title = webView.stringByEvaluatingJavaScript(from: "document.title")
    }
}
// MARK: - UI
extension RNWebViewController {
    private func setupUI() {
        view.backgroundColor = UIColor.white
        webView.backgroundColor = UIColor.white
        webView.delegate = self
        view.addSubview(webView)
    }
    override func setupTableView() { }
}
