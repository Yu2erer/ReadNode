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

    private let placeholderView = RNPlaceholderView(frame: CGRect(x: 0, y: 0, width: UIScreen.nt_screenWidth, height: UIScreen.nt_screenHeight))

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView?.reloadData()
    }
}
// MARK: - UITableView
extension RNLikeViewController: SwipeTableViewCellDelegate {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = RNSQLiteManager.shared.likeRssFeedItemList.count
        if count == 0 {
            tableView.isHidden = true
            placeholderView.isHidden = false
        } else {
            tableView.isHidden = false
            placeholderView.isHidden = true
        }
        return count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: feedItemLikeCellId, for: indexPath) as! RNLikeTableViewCell
        cell.delegate = self
        cell.likeCellDelegate = self
        cell.model = RNSQLiteManager.shared.likeRssFeedItemList[indexPath.row]
//         隐藏最后一项分割线
        cell.separatorView.isHidden = indexPath.row == RNSQLiteManager.shared.likeRssFeedItemList.count - 1
        return cell
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        let item = RNSQLiteManager.shared.likeRssFeedItemList[indexPath.row]
        if orientation == .right {
            let delete = SwipeAction(style: .default, title: nil, handler: { (action, indexPath) in
                item.isLike = false
                RNSQLiteManager.shared.removeLikeFeedItem(item.itemLink ?? "")
                tableView.deleteRows(at: [indexPath], with: .left)
                NTMessageHud.showMessage(message: NSLocalizedString("Uncollected", comment: "Uncollected"))
            })
            delete.backgroundColor = UIColor.red
            delete.hidesWhenSelected = true
            delete.image = UIImage(named: "trash")
            return [delete]
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
// MARK: - RNLikeTableViewCellDelegate
extension RNLikeViewController: RNLikeTableViewCellDelegate {
    func didClickStatus(item: RNRssFeedItem) {
        let vc = RNFeedDetailsViewController()
        vc.item = item
        navigationController?.pushViewController(vc, animated: true)
    }
}
// MARK: - UI
extension RNLikeViewController {
    private func setupUI() {
        navigationItem.titleView = UILabel.nt_label(text: NSLocalizedString("Favourites", comment: "Favourites"), textColor: UIColor.nt_color(hex: 0x34394B), font: UIFont(name: "PingFang", size: 12))
        view.addSubview(placeholderView)
        placeholderView.placeholderInfo = ["imageName": "likePlaceholder", "message": NSLocalizedString("This list is empty.", comment: "This list is empty.")]
    }
    override func setupTableView() {
        super.setupTableView()
        tableView?.estimatedRowHeight = 110
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.separatorStyle = .none
        tableView?.register(UINib(nibName: "RNLikeTableViewCell", bundle: nil), forCellReuseIdentifier: feedItemLikeCellId)
        tableView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: (navigationController?.navigationBar.bounds.height ?? 44) + 20, right: 0)
        tableView?.scrollIndicatorInsets = tableView!.contentInset
        refreshControl?.removeFromSuperview()
    }
}
