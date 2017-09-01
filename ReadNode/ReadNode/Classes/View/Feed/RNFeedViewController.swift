//
//  RNFeedViewController.swift
//  ReadNode
//
//  Created by ntian on 2017/8/9.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit
import Popover
import SVProgressHUD
import SwipeCellKit

private let authorCellId = "authorCellId"

class RNFeedViewController: RNBaseViewController {
    
    fileprivate lazy var popover = Popover()
    fileprivate lazy var addView: RNAddView = Bundle.main.loadNibNamed("RNAddView", owner: nil, options: nil)?.last as! RNAddView
    fileprivate let placeholderView = RNPlaceholderView(frame: CGRect(x: 0, y: 0, width: UIScreen.nt_screenWidth, height: UIScreen.nt_screenHeight))

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
    @objc fileprivate func add(_ sender: UIButton) {
        // 针对 iOS 10 震动反馈
        if #available(iOS 10.0, *) {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        }
        // 放大动画
        let btnAnime = CAKeyframeAnimation(keyPath: "transform.scale")
        btnAnime.values = [1.0,0.7,0.5,0.3,0.5,0.7,1.0,1.2,1.4,1.2,1.0]
        btnAnime.keyTimes = [0.0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0]
        btnAnime.duration = 0.2
        sender.layer.add(btnAnime, forKey: "SHOW")
        addView.frame = CGRect(x: 0, y: 0, width: UIScreen.nt_screenWidth - 20, height: 200)
        
        popover.show(addView, point: CGPoint(x: view.bounds.width / 2, y: 74))
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
        let count = RNSQLiteManager.shared.rssFeedList.count
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
        let rssFeed = RNSQLiteManager.shared.rssFeedList[indexPath.row]
        if orientation == .right {
            let delete = SwipeAction(style: .default, title: nil) { action, indexPath in
                RNSQLiteManager.shared.removeRssFeed(rssFeed.link!)
                RNSQLiteManager.shared.rssFeedList.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .left)
            }
            delete.backgroundColor = .red
            delete.hidesWhenSelected = true
            delete.image = UIImage(named: "trash")
            return [delete]
        } else {
            let like = SwipeAction(style: .default, title: nil, handler: { (action, indexPath) in
                if (rssFeed.items?.first?.isLike)! {
                    rssFeed.items?.first?.isLike = false
                    RNSQLiteManager.shared.removeLikeFeedItem(rssFeed.items?.first?.itemLink ?? "")
                    NTMessageHud.showMessage(message: "Uncollected")
                } else {
                    rssFeed.items?.first?.isLike = true
                    RNSQLiteManager.shared.addLikeFeedItem((rssFeed.items?.first)!)
                    NTMessageHud.showMessage(message: "Collected")
                }
            })
            like.backgroundColor = UIColor.orange
            like.hidesWhenSelected = true
            if (rssFeed.items?.first?.isLike)! {
                like.image = UIImage(named: "unfav")
            } else {
                like.image = UIImage(named: "fav")
            }
            return [like]
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
// MARK: - RNAddViewDelegate
extension RNFeedViewController: RNAddViewDelegate {
    func didClickClose() {
        popover.dismiss()
    }
    func didClickSave(urlString: String) {
        popover.dismiss()
        SVProgressHUD.show()
        RNNetworkManager.shared.request(urlString: urlString) { (rssFeed, isSuccess) in
            SVProgressHUD.dismiss()
            if !isSuccess {
                NTMessageHud.showMessage(message: "No sources found.Please enter a valid site url")
                return
            }
            NTMessageHud.showMessage(message: rssFeed?.title)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: RNAddFeedNotification), object: nil)
        }
    }
}
// MARK: - UI
extension RNFeedViewController {
    fileprivate func setupUI() {
        navigationItem.titleView = UILabel.nt_label(text: "ReadNode", textColor: UIColor.nt_color(hex: 0x34394B), font: UIFont(name: "PingFang", size: 12))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image:UIImage(named: "nav-filter"), style: .plain, target: self, action: #selector(test))
        view.backgroundColor = UIColor.white
        view.addSubview(placeholderView)      
//        // 传递闭包
//        placeholderView.completionCallBack = {
//            self.tabBarController?.selectedIndex = 2
//        }
        // addBtn
        let addBtn = UIButton(type: .custom)
        addBtn.frame = CGRect(x: view.bounds.width - 12 - 50, y: view.bounds.height - 12 - 64 - 49 - 50, width: 50, height: 50)
        addBtn.setImage(UIImage(named: "addButton"), for: .normal)
        addBtn.addTarget(self, action: #selector(add), for: .touchUpInside)
        view.addSubview(addBtn)
        // popover
        let popoverOptions: [PopoverOption] = [
            .type(.down),
            .arrowSize(CGSize(width: 0.1, height: 0.1)),
            .cornerRadius(10.0),
            .blackOverlayColor(UIColor(white: 0.0, alpha: 0.4))
        ]
        popover = Popover(options: popoverOptions)
        popover.dismissOnBlackOverlayTap = false
        addView.frame = CGRect(x: 0, y: 0, width: UIScreen.nt_screenWidth - 20, height: 200)
        addView.viewDelegate = self
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
