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
    /// 上拉刷新标记
    var isPullup = false

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        loadData()
    }
    /// 具体实现由子类负责
    func loadData() {
        
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
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let row = indexPath.row
        let section = tableView.numberOfSections - 1
        if row < 0 || section < 0 {
            return
        }
        let count = tableView.numberOfRows(inSection: section)
        if row == (count - 1) && !isPullup {
            isPullup = true
            loadData()
        }
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
        tableView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom:         (tabBarController?.tabBar.bounds.height ?? 49) + (navigationController?.navigationBar.bounds.height ?? 44) + 20, right: 0)
        tableView?.scrollIndicatorInsets = tableView!.contentInset
        // 实现表格代理方法和数据源方法
        tableView?.delegate = self
        tableView?.dataSource = self
    }
}
