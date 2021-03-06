//
//  RNAuthorFeedDetailsViewController.swift
//  ReadNode
//
//  Created by ntian on 2017/8/20.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit
import SwipeCellKit

private let authorFeedDetailsCellId = "authorFeedDetailsCellId"

class RNAuthorFeedDetailsViewController: RNBaseViewController {

    var model: RNRssFeed?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

    }
    @objc private func clickTitleButton() {
        let vc = RNWebViewController()
        vc.urlString = model?.link
        navigationController?.pushViewController(vc, animated: true)
    }
}
// MARK: - UITableView
extension RNAuthorFeedDetailsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.items?.count ?? 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: authorFeedDetailsCellId, for: indexPath) as! RNAuthorFeedDetailsCell
        cell.detailsCellDelegate = self
        cell.model = model?.items?[indexPath.row]
        // 隐藏最后一项分割线
        cell.separatorView.isHidden = indexPath.row == (model?.items?.count)! - 1
        return cell
    }
}
// MARK: - RNAuthorFeedDetailsCellDelegate
extension RNAuthorFeedDetailsViewController: RNAuthorFeedDetailsCellDelegate {
    func didClickStatus(item: RNRssFeedItem) {
        let vc = RNFeedDetailsViewController()
        vc.item = item
        navigationController?.pushViewController(vc, animated: true)
    }
}
// MARK: - UI
extension RNAuthorFeedDetailsViewController {
    private func setupUI() {
        view.backgroundColor = UIColor.white
        let titleButton = RNTitleButton(title: model?.title ?? "", imageUrlString: model?.iconLink ?? "")
        
        titleButton.addTarget(self, action: #selector(clickTitleButton), for: .touchUpInside)
        navigationItem.titleView = titleButton
    }
    override func setupTableView() {
        super.setupTableView()
        tableView?.estimatedRowHeight = 80
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.separatorStyle = .none
        tableView?.register(UINib(nibName: "RNAuthorFeedDetailsCell", bundle: nil), forCellReuseIdentifier: authorFeedDetailsCellId)
        tableView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: (navigationController?.navigationBar.bounds.height ?? 44) + 20, right: 0)
        tableView?.scrollIndicatorInsets = tableView!.contentInset
        refreshControl?.removeFromSuperview()
    }
}
