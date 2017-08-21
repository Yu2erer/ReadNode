//
//  RNFeedViewController.swift
//  ReadNode
//
//  Created by ntian on 2017/8/9.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit

private let authorCellId = "authorCellId"

class RNFeedViewController: RNBaseViewController {

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
        
    }
    @objc fileprivate func reload() {
        tableView?.reloadData()
    }
    @objc fileprivate func test() {
        let vc = RNDemoViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

}
// MARK: - UITableViewDataSource, UITableViewDelegate
extension RNFeedViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RNSQLite.shared.rssFeedList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: authorCellId, for: indexPath) as! RNFeedAuthorCell
        cell.authorCellDelegate = self
        cell.model = RNSQLite.shared.rssFeedList[indexPath.row]
        // 让最后一项的分割线隐藏起来
        cell.separatorView.isHidden = indexPath.row == RNSQLite.shared.rssFeedList.count - 1
        return cell
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
