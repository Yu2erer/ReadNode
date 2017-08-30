//
//  RNLikeViewController.swift
//  ReadNode
//
//  Created by ntian on 2017/8/9.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit
import SwipeCellKit

private let feedItemLikeCellId = "feedItemLikeCellId"

class RNLikeViewController: RNBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    override func setupTableView() {
        super.setupTableView()
        tableView?.estimatedRowHeight = 80
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.separatorStyle = .none
        tableView?.register(UINib(nibName: "RNAuthorFeedDetailsCell", bundle: nil), forCellReuseIdentifier: feedItemLikeCellId)
        tableView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: (navigationController?.navigationBar.bounds.height ?? 44) + 20, right: 0)
        tableView?.scrollIndicatorInsets = tableView!.contentInset
        refreshControl?.removeFromSuperview()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView?.reloadData()
    }


}
// MARK: - UITableView
extension RNLikeViewController: SwipeTableViewCellDelegate {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RNSQLiteManager.shared.likeRssFeedItemList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: feedItemLikeCellId, for: indexPath) as! RNAuthorFeedDetailsCell
//        cell.delegate = self
//        cell.detailsCellDelegate = self
        cell.model = RNSQLiteManager.shared.likeRssFeedItemList[indexPath.row]
        // 隐藏最后一项分割线
        cell.separatorView.isHidden = indexPath.row == RNSQLiteManager.shared.likeRssFeedItemList.count - 1
        return cell
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        let item = RNSQLiteManager.shared.likeRssFeedItemList[indexPath.row]
        if orientation == .right {
            let like = SwipeAction(style: .default, title: nil, handler: { (action, indexPath) in
                if item.isLike {
                    item.isLike = false
                    RNSQLiteManager.shared.removeLikeFeedItem(item.itemLink ?? "")
                    RNSQLiteManager.shared.likeRssFeedItemList.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .left)
                    NTMessageHud.showMessage(message: "Uncollected")
                } else {
                    item.isLike = true
                    RNSQLiteManager.shared.addLikeFeedItem(item)
                    NTMessageHud.showMessage(message: "Collected")
                }
            })
            like.backgroundColor = UIColor.orange
            like.hidesWhenSelected = true
            if item.isLike {
                like.image = UIImage(named: "unfav")
            } else {
                like.image = UIImage(named: "fav")
            }
            return [like]
        } else {
            return []
        }
    }
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .selection
        options.backgroundColor = UIColor.nt_color(hex: 0xDCDCDC)
        return options
    }
}
// MARK: - UI
extension RNLikeViewController {
    fileprivate func setupUI() {
        navigationItem.titleView = UILabel.titleView(text: "Favourites", textColor: UIColor.nt_color(hex: 0x34394B), font: UIFont(name: "PingFang", size: 12))
    }
}
