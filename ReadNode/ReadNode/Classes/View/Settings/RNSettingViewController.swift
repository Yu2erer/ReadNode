//
//  RNSettingViewController.swift
//  ReadNode
//
//  Created by ntian on 2017/9/2.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit
import StoreKit
import SVProgressHUD

private let basicId = "basicId"
private let numformatter = NumberFormatter()

class RNSettingViewController: UIViewController {
    
    private lazy var groups = [RNSettingsGroupItem]()
    private lazy var authorLabel = UILabel()
    private var tableView: UITableView?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SKPaymentQueue.default().add(self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    deinit {
        SKPaymentQueue.default().remove(self)
    }
    private func verify(review: Bool) {
        let receiptUrl = Bundle.main.appStoreReceiptURL
        let receiveData = NSData(contentsOf: receiptUrl!)
        let receiptString = receiveData?.base64EncodedString(options: .endLineWithLineFeed)
        let bodyString = NSString(string: "{\"receipt-data\" : \"" + receiptString! + "\"}") as String

        let bodyData = bodyString.data(using: .utf8)
        var url = VERIFY_RECEIPT_URL
        if review {
            url = ITMS_SANDBOX_VERIFY_RECEIPT_URL
        }
        var request = URLRequest(url: url)
        request.httpBody = bodyData
        request.httpMethod = "POST"
        let responseData = try? NSURLConnection.sendSynchronousRequest(request, returning: nil)
        guard var dic = try? JSONSerialization.jsonObject(with: responseData!, options: .allowFragments) as? [String: Any] else {
            SVProgressHUD.dismiss()
            NTMessageHud.showMessage(message: NSLocalizedString("Verify Failed, Please Restore Purchase", comment: "Verify Failed, Please Restore Purchase"))
            return
        }
        if dic?["status"] as? Int == 21007 {
            verify(review: true)
        } else if dic?["status"] as? Int == 0 {
            SVProgressHUD.dismiss()
            UserDefaults.standard.set(bodyData, forKey: "purchaseData")
            purchaseData = bodyData
            NTMessageHud.showMessage(message: NSLocalizedString("Purchase Completed 😘~", comment: "Purchase Completed 😘~"))
            navigationItem.rightBarButtonItem = nil
        } else {
            SVProgressHUD.dismiss()
            NTMessageHud.showMessage(message: NSLocalizedString("Verify Failed, Please Restore Purchase", comment: "Verify Failed, Please Restore Purchase"))
        }
    }
    @objc private func gopro() {
        guard let product = product else {
            return
        }
        let alertView = UIAlertController(title: "ReadNode Pro", message: NSLocalizedString("•  iCloud data synchronization", comment: "•  iCloud data synchronization"), preferredStyle: .alert)
        numformatter.formatterBehavior = .behavior10_4
        numformatter.numberStyle = .currency
        numformatter.locale = product.priceLocale
        let payAction = UIAlertAction(title: "Pay \(numformatter.string(from: product.price) ?? "¥12.00")", style: .default) { (_) in
            // 开交易凭证
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
            DispatchQueue.main.async {
                SVProgressHUD.show()
            }
        }
        let restoreAction = UIAlertAction(title: NSLocalizedString("Restore Purchase", comment: "Restore Purchase"), style: .default) { (_) in
            SKPaymentQueue.default().restoreCompletedTransactions()
            DispatchQueue.main.async {
                SVProgressHUD.show()
            }
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .destructive, handler: nil)
        alertView.addAction(payAction)
        alertView.addAction(restoreAction)
        alertView.addAction(cancelAction)
        present(alertView, animated: true)
    }
}
// MARK: - SKProductsRequestDelegate, SKPaymentTransactionObserver
extension RNSettingViewController: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing:
                print("正在购买中")
                break
            case .purchased:
                print("购买完成")
                verify(review: false)
                SKPaymentQueue.default().finishTransaction(transaction)
                break
            case .failed:
                let error = transaction.error as? SKError
                print("购买失败\(String(describing: error?.localizedDescription))")
                SVProgressHUD.dismiss()
                NTMessageHud.showMessage(message: NSLocalizedString("Purchase Failed", comment: "Purchase Failed"))
                SKPaymentQueue.default().finishTransaction(transaction)
                break
            case .restored:
                print("恢复购买")
                verify(review: false)
                SKPaymentQueue.default().finishTransaction(transaction)
                break
            case .deferred:
                print("无法判断")
                SVProgressHUD.dismiss()
                NTMessageHud.showMessage(message: NSLocalizedString("Purchase Error", comment: "Purchase Error"))
                break
            }
        }
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
    private func setupUI() {
        view.backgroundColor = UIColor.white
        navigationItem.titleView = UILabel.nt_label(text: NSLocalizedString("Settings", comment: "Settings"), textColor: UIColor.nt_color(hex: 0x34394B), font: UIFont(name: "PingFang", size: 12))
        if purchaseData == nil {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Go Pro", style: .done, target: self, action: #selector(gopro))
        }
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
    private func setupData() {
        let groupData = RNSettingsGroupItem()
        groupData.headTitle = NSLocalizedString("DATA", comment: "DATA")
        let emptyFav = RNSettingsItem()
        emptyFav.title = NSLocalizedString("Empty Favorites", comment: "Empty Favorites")
        emptyFav.completionCallBack = {
            let alertController = UIAlertController(title: NSLocalizedString("Delete All?", comment: "Delete All?"), message: nil, preferredStyle: .alert)
            let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: UIAlertActionStyle.cancel, handler: nil)
            let clear = UIAlertAction(title: NSLocalizedString("Clear", comment: "Clear"), style: UIAlertActionStyle.destructive, handler: { (_) in
                for item in RNSQLiteManager.shared.likeRssFeedItemList {
                    RNSQLiteManager.shared.removeLikeFeedItem(item.itemLink ?? "")
                }
                RNSQLiteManager.shared.likeRssFeedItemList.removeAll()
                NTMessageHud.showMessage(message: NSLocalizedString("Clear Finished", comment: "Clear Finished"))
            })
            alertController.addAction(clear)
            alertController.addAction(cancel)
            self.present(alertController, animated: true, completion: nil)
        }
        groupData.items = [emptyFav]
        groups.append(groupData)
        let groupiCloud = RNSettingsGroupItem()
        groupiCloud.headTitle = NSLocalizedString("ICLOUD SYNC", comment: "ICLOUD SYNC")
        let icloudRestore = RNSettingsItem()
        icloudRestore.title = NSLocalizedString("Restore data from iCloud", comment: "Restore data from iCloud")
        icloudRestore.completionCallBack = {
            if purchaseData == nil {
                self.gopro()
                return
            }
            SVProgressHUD.show()
            RNCloudKitManager.shared.accountStatus(completion: { (isAvailable) in
                if isAvailable {
                    RNCloudKitManager.shared.fetch(recordName: "ReadNode", move: rnDBPath, completion: { (isSuccess, errorCode) in
                        if !isSuccess {
                            if errorCode == 11 {
                                DispatchQueue.main.async {
                                    NTMessageHud.showMessage(message: NSLocalizedString("The restore data was not found", comment: "The restore data was not found"))
                                }
                            } else {
                                DispatchQueue.main.async {
                                    NTMessageHud.showMessage(message: NSLocalizedString("Restore Data Failed", comment: "Restore Data Failed"))
                                }
                            }
                            SVProgressHUD.dismiss()
                            return
                        }
                        RNCloudKitManager.shared.fetch(recordName: "LikeReadNode", move: likeDBpath, completion: { (isSuccess, errorCode) in
                            if !isSuccess {
                                if errorCode == 11 {
                                    NTMessageHud.showMessage(message: NSLocalizedString("The restore data was not found", comment: "The restore data was not found"))
                                } else {
                                    DispatchQueue.main.async {
                                        NTMessageHud.showMessage(message: NSLocalizedString("Restore Data Failed", comment: "Restore Data Failed"))
                                    }
                                }
                                SVProgressHUD.dismiss()
                                return
                            }
                            DispatchQueue.main.async {
                                NTMessageHud.showMessage(message: NSLocalizedString("Restore Data Successfully", comment: "Restore Data Successfully"))
                            }
                            SVProgressHUD.dismiss()
                            RNSQLiteManager.shared.reload()
                        })
                    })
                } else {
                    DispatchQueue.main.async {
                        NTMessageHud.showMessage(message: NSLocalizedString("iCloud is unavailable.", comment: "iCloud is unavailable."))
                    }
                }
            })
        }
        let icloudBackup = RNSettingsItem()
        icloudBackup.title = NSLocalizedString("Backup data to iCloud", comment: "Backup data to iCloud")
        icloudBackup.completionCallBack = {
            if purchaseData == nil {
                self.gopro()
                return
            }
            SVProgressHUD.show()
            RNCloudKitManager.shared.accountStatus(completion: { (isAvailable) in
                if isAvailable {
                    RNCloudKitManager.shared.delete(recordName: "ReadNode", completion: { (isSuccess) in
                        if !isSuccess {
                            DispatchQueue.main.async {
                                NTMessageHud.showMessage(message: NSLocalizedString("Backup Data Failed", comment: "Backup Data Failed"))
                            }
                            SVProgressHUD.dismiss()
                            return
                        }
                        RNCloudKitManager.shared.delete(recordName: "LikeReadNode", completion: { (isSuccess) in
                            if !isSuccess {
                                DispatchQueue.main.async {
                                    NTMessageHud.showMessage(message: NSLocalizedString("Backup Data Failed", comment: "Backup Data Failed"))
                                }
                                SVProgressHUD.dismiss()
                                return
                            }
                        })
                        RNCloudKitManager.shared.save(fileUrlString: rnDBPath, recordName: "ReadNode", completion: { (isSuccess) in
                            if !isSuccess {
                                DispatchQueue.main.async {
                                    NTMessageHud.showMessage(message: NSLocalizedString("Backup Data Failed", comment: "Backup Data Failed"))
                                }
                            } else {
                                RNCloudKitManager.shared.save(fileUrlString: likeDBpath, recordName: "LikeReadNode", completion: { (isSuccess) in
                                    if !isSuccess {
                                        DispatchQueue.main.async {
                                            NTMessageHud.showMessage(message: NSLocalizedString("Backup Data Failed", comment: "Backup Data Failed"))
                                        }
                                    } else {
                                        DispatchQueue.main.async {
                                            NTMessageHud.showMessage(message: NSLocalizedString("Backup Data Successfully", comment: "Backup Data Successfully"))
                                        }
                                    }
                                })
                            }
                            SVProgressHUD.dismiss()
                        })
                    })

                } else {
                    DispatchQueue.main.async {
                        NTMessageHud.showMessage(message: NSLocalizedString("iCloud is unavailable.", comment: "iCloud is unavailable."))
                    }
                    SVProgressHUD.dismiss()
                }
            })
        }
        groupiCloud.items = [icloudRestore, icloudBackup]
        // 隐藏 icloud
        groups.append(groupiCloud)
        let groupMedia = RNSettingsGroupItem()
        groupMedia.headTitle = NSLocalizedString("SOCIAL MEDIA", comment: "SOCIAL MEDIA")
        let telegram = RNSettingsItem()
        telegram.title = "Telegram"
        telegram.completionCallBack = {
            let url = URL(string: "tg://join?invite=FAcPYEDJVB15dGpJI19-1Q")
            UIApplication.shared.openURL(url!)
        }
        groupMedia.items = [telegram]
        groups.append(groupMedia)
        let groupMisc = RNSettingsGroupItem()
        groupMisc.headTitle = NSLocalizedString("MISC", comment: "MISC")
        let recommend = RNSettingsItem()
        recommend.title = NSLocalizedString("Recommend ReadNode", comment: "Recommend ReadNode")
        recommend.completionCallBack = {
            UIPasteboard.general.string = "https://itunes.apple.com/cn/app/readnode-rss-reader/id1271352688?mt=8https://itunes.apple.com/cn/app/readnode-rss-reader/id1271352688?mt=8"
            NTMessageHud.showMessage(message: NSLocalizedString("ReadNode URL Copied", comment: "ReadNode URL Copied"))
        }
        let rate = RNSettingsItem()
        rate.title = NSLocalizedString("Rate On App Store", comment: "Rate On App Store")
        rate.completionCallBack = {
            let url = URL(string: "itms-apps://itunes.apple.com/app/id1271352688")
            UIApplication.shared.openURL(url!)
        }
        groupMisc.items = [recommend, rate]
        groups.append(groupMisc)
    }
}
