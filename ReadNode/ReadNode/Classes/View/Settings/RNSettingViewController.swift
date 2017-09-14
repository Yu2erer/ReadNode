//
//  RNSettingViewController.swift
//  ReadNode
//
//  Created by ntian on 2017/9/2.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit

private let basicId = "basicId"

class RNSettingViewController: UIViewController {

    fileprivate lazy var groups = [RNSettingsGroupItem]()
    fileprivate lazy var authorLabel = UILabel()
    fileprivate var tableView: UITableView?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}
// MARK: - UITableViewDelegate, UITableViewDataSource
extension RNSettingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return groups.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups[section].items?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: basicId, for: indexPath) as! RNBasicTableViewCell
        cell.item = groups[indexPath.section].items?[indexPath.row]
        return cell
        
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return groups[section].headTitle
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let block = groups[indexPath.section].items?[indexPath.row].completionCallBack
        block?()
    }
}
// MARK: - UI
extension RNSettingViewController {
    fileprivate func setupUI() {
        view.backgroundColor = UIColor.white
        navigationItem.titleView = UILabel.nt_label(text: "Settings", textColor: UIColor.nt_color(hex: 0x34394B), font: UIFont(name: "PingFang", size: 12))
        setupData()
        automaticallyAdjustsScrollViewInsets = false
        tableView = UITableView(frame: view.bounds, style: .grouped)
        view.addSubview(tableView!)
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.register(RNBasicTableViewCell.self, forCellReuseIdentifier: basicId)
        tableView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom:         (tabBarController?.tabBar.bounds.height ?? 49) + 44, right: 0)
        tableView?.scrollIndicatorInsets = (tableView?.contentInset)!
        authorLabel.text = "Version \(Bundle.currentVerison) 🌚Made by Ntian"
        authorLabel.textAlignment = .center
        authorLabel.textColor = UIColor.nt_color(hex: 0xA9AAAA)
        authorLabel.font = UIFont.systemFont(ofSize: 10)
        authorLabel.sizeToFit()
        tableView?.tableFooterView = authorLabel
    }
    // tableViewCell 的设置 乱七八糟 谨慎打开
    fileprivate func setupData() {
        let groupiCloud = RNSettingsGroupItem()
        groupiCloud.headTitle = "ICLOUD SYNC"
        let icloud = RNSettingsItem()
        icloud.title = "iCloud"
        icloud.completionCallBack = {
            RNCloudKitManager.shared.accountStatus(completion: { (isAvailable) in
                if isAvailable {
                    DispatchQueue.main.async {
                        NTMessageHud.showMessage(message: "可用")
                    }
                } else {
                    DispatchQueue.main.async {
                        NTMessageHud.showMessage(message: "iCloud is unavailable. Please check it.")
                    }
                }
            })
        }
        let icloud2 = RNSettingsItem()
        icloud2.title = "iCloud"
        groupiCloud.items = [icloud, icloud2]
        groups.append(groupiCloud)
        let groupData = RNSettingsGroupItem()
        groupData.headTitle = "DATA"
        let emptyFav = RNSettingsItem()
        emptyFav.title = "Empty Favorites"
        emptyFav.completionCallBack = {
            let alertController = UIAlertController(title: "Delete All?", message: nil, preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
            let clear = UIAlertAction(title: "Clear", style: UIAlertActionStyle.destructive, handler: { (_) in
                for item in RNSQLiteManager.shared.likeRssFeedItemList {
                    RNSQLiteManager.shared.removeLikeFeedItem(item.itemLink ?? "")
                }
                RNSQLiteManager.shared.likeRssFeedItemList.removeAll()
                NTMessageHud.showMessage(message: "Clear Finished")
            })
            alertController.addAction(clear)
            alertController.addAction(cancel)
            self.present(alertController, animated: true, completion: nil)
        }
        groupData.items = [emptyFav]
        groups.append(groupData)
        let groupMedia = RNSettingsGroupItem()
        groupMedia.headTitle = "SOCIAL MEDIA"
        let telegram = RNSettingsItem()
        telegram.title = "Telegram"
        telegram.completionCallBack = {
            let url = URL(string: "tg://join?invite=FAcPYEDJVB15dGpJI19-1Q")
            UIApplication.shared.openURL(url!)
        }
        groupMedia.items = [telegram]
        groups.append(groupMedia)
        let groupMisc = RNSettingsGroupItem()
        groupMisc.headTitle = "MISC"
        let recommend = RNSettingsItem()
        recommend.title = "Recommend ReadNode"
        recommend.completionCallBack = {
            UIPasteboard.general.string = "https://itunes.apple.com/cn/app/readnode-rss-reader/id1271352688?mt=8https://itunes.apple.com/cn/app/readnode-rss-reader/id1271352688?mt=8"
            NTMessageHud.showMessage(message: "ReadNode URL Copied")
        }
        let rate = RNSettingsItem()
        rate.title = "Rate On App Store"
        rate.completionCallBack = {
            let url = URL(string: "itms-apps://itunes.apple.com/app/id1271352688")
            UIApplication.shared.openURL(url!)
        }
        groupMisc.items = [recommend, rate]
        groups.append(groupMisc)
    }
}
