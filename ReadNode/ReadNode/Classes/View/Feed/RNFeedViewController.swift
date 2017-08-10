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
    }
    override func setupTableView() {
        super.setupTableView()
        // 自动设置行高
        tableView?.estimatedRowHeight = 105
        tableView?.rowHeight = UITableViewAutomaticDimension
        // 去除分割线
        tableView?.separatorStyle = .none
        tableView?.register(UINib(nibName: "RNFeedAuthorCell", bundle: nil), forCellReuseIdentifier: authorCellId)
    }

    @objc fileprivate func test() {
        let vc = RNDemoViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

}
// MARK: - UITableViewDataSource, UITableViewDelegate
extension RNFeedViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: authorCellId, for: indexPath)
        return cell
    }
}
// MARK: - UI
extension RNFeedViewController {
    fileprivate func setupUI() {
        navigationItem.title = "ReadNode"
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "tabbar-search", target: self, action: #selector(test))
        view.backgroundColor = UIColor.white
    }
}
