//
//  RNFeedViewController.swift
//  ReadNode
//
//  Created by ntian on 2017/8/9.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit
import SwipeCellKit

private let authorCellId = "authorCellId"

class RNFeedViewController: RNBaseViewController {
    /// 刷新项目标记
    fileprivate var num = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name(rawValue: RNAddFeedNotification), object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reload()
    }
    override func loadData() {
        let count = RNSQLiteManager.shared.rssFeedList.count
        if count == 0 {
            self.refreshControl?.endRefreshing()
            NTMessageHud.showMessage(message: "Please add at least one Rss")
            return
        }
        guard let feedLink = RNSQLiteManager.shared.rssFeedList[num].feedLink else {
            return
        }
        RNNetworkManager.shared.updateRequest(urlString: feedLink, completion: { (rssFeed, isSuccess) in
            if !isSuccess {
                NTMessageHud.showMessage(message: "No sources found.Please enter a valid site url")
                if self.num == count - 1 {
                    self.refreshControl?.endRefreshing()
                    self.num = 0
                } else if self.num < count - 1 {
                    self.num += 1
                    self.loadData()
                }
                return
            }
            NTMessageHud.showMessage(message: (rssFeed?.title)! + " Update Finished")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: RNAddFeedNotification), object: nil)
            if self.num == count - 1 {
                self.num = 0
                self.refreshControl?.endRefreshing()
            } else if self.num < count - 1 {
                self.num += 1
                self.loadData()
            }
        })
    }
    
    @objc fileprivate func reload() {
        tableView?.reloadData()
    }
    @objc fileprivate func test() {
        let vc = RNDemoViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

}
// MARK: - UITableViewDataSource, UITableViewDelegate, SwipeTableViewCellDelegate
extension RNFeedViewController: SwipeTableViewCellDelegate {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RNSQLiteManager.shared.rssFeedList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: authorCellId, for: indexPath) as! RNFeedAuthorCell
        cell.authorCellDelegate = self
        // SwipeCellKit
        cell.delegate = self
        cell.model = RNSQLiteManager.shared.rssFeedList[indexPath.row]
        // 让最后一项的分割线隐藏起来
        cell.separatorView.isHidden = indexPath.row == RNSQLiteManager.shared.rssFeedList.count - 1
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        if orientation == .right {
            let like = SwipeAction(style: .default, title: nil, handler: { (action, indexPath) in
                RNSQLiteManager.shared.rssFeedList[indexPath.row].items?.first?.isLike = true
                RNSQLiteManager.shared.updateRssFeed(RNSQLiteManager.shared.rssFeedList[indexPath.row])
                
            })
            like.backgroundColor = UIColor.orange
            like.hidesWhenSelected = true
            like.image = UIImage(named: "fav")

            let delete = SwipeAction(style: .default, title: nil) { action, indexPath in
                RNSQLiteManager.shared.removeRssFeed(RNSQLiteManager.shared.rssFeedList[indexPath.row].link!)
                RNSQLiteManager.shared.rssFeedList.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .left)
            }
            delete.backgroundColor = .red
            delete.hidesWhenSelected = true
            delete.image = UIImage(named: "trash")
            return [like, delete]
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
// MARK: - RNFeedAuthorCellDelegate
extension RNFeedViewController: RNFeedAuthorCellDelegate {
    func didClickAuthor(model: RNRssFeed) {
        let vc = RNAuthorFeedDetailsViewController()
        vc.model = model
        navigationController?.pushViewController(vc, animated: true)
    }
    func didClickStatus(item: RNRssFeedItem) {
        let vc = RNFeedDetailsViewController()
        vc.item = item
        navigationController?.pushViewController(vc, animated: true)
    }
}
// MARK: - UI
extension RNFeedViewController {
    fileprivate func setupUI() {
        navigationItem.titleView = UILabel.titleView(text: "ReadNode", textColor: UIColor.nt_color(hex: 0x34394B), font: UIFont(name: "PingFang", size: 12))
//        navigationItem.rightBarButtonItem = UIBarButtonItem(image:UIImage(named: "nav-filter"), style: .plain, target: self, action: #selector(test))
        view.backgroundColor = UIColor.white
    }
    override func setupTableView() {
        super.setupTableView()
        // 自动设置行高
        tableView?.estimatedRowHeight = 110
        tableView?.rowHeight = UITableViewAutomaticDimension
        // 去除分割线
        tableView?.separatorStyle = .none
        tableView?.register(UINib(nibName: "RNFeedAuthorCell", bundle: nil), forCellReuseIdentifier: authorCellId)
    }

}
