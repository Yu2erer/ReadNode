//
//  RNBaseViewController.swift
//  ReadNode
//
//  Created by ntian on 2017/8/10.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit

class RNBaseViewController: UIViewController {
    
    /// 表格视图
    var tableView: UITableView?
    /// 刷新控件
    var refreshControl: NTRefreshControl?
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    /// 具体实现由子类负责
    func loadData() {
        self.refreshControl?.endRefreshing()
    }
}
// MARK: - UITableViewDelegate, UITableViewDataSource
extension RNBaseViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
// MARK: - UI
extension RNBaseViewController {
    
    fileprivate func setupUI() {
        setupTableView()
    }
    func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        view.addSubview(tableView!)
        // 取消自动缩进
        automaticallyAdjustsScrollViewInsets = false
        tableView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom:         (tabBarController?.tabBar.bounds.height ?? 49) + 20, right: 0)
        tableView?.scrollIndicatorInsets = tableView!.contentInset
        // 实现表格代理方法和数据源方法
        tableView?.delegate = self
        tableView?.dataSource = self
        refreshControl = NTRefreshControl()
        tableView?.addSubview(refreshControl!)
        refreshControl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
    }
}
