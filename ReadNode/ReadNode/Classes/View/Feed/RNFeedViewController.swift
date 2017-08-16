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
    override func loadData() {
        
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

    @objc fileprivate func test() {
        NTMessageHud.showMessage(message: "red")
//        let vc = RNDemoViewController()
//        navigationController?.pushViewController(vc, animated: true)
    }

}
// MARK: - UITableViewDataSource, UITableViewDelegate
extension RNFeedViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: authorCellId, for: indexPath)
        return cell
    }
}
// MARK: - UI
extension RNFeedViewController {
    fileprivate func setupUI() {
        navigationItem.titleView = UILabel.titleView(text: "ReadNode", textColor: UIColor.nt_color(hex: 0x34394B), font: UIFont(name: "PingFang", size: 12))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image:UIImage(named: "nav-filter"), style: .plain, target: self, action: #selector(test))
        view.backgroundColor = UIColor.white
    }
}
