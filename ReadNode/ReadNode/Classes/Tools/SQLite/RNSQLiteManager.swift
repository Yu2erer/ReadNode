//
//  RNSQLiteManager.swift
//  SQLite
//
//  Created by ntian on 2017/8/22.
//  Copyright © 2017年 ntian. All rights reserved.
//

import Foundation
import FMDB
import YYModel

class RNSQLiteManager {
    
    static let shared = RNSQLiteManager()
    lazy var rssFeedList = [RNRssFeed]()
    lazy var likeRssFeedItemList = [RNRssFeedItem]()
    
    func addRssFeed(_ rssFeed: RNRssFeed) {
        guard let jsonObj = rssFeed.yy_modelToJSONObject() else {
            return
        }
        insertReadNode(array: jsonObj as! [String: Any], isLike: false)
        rssFeedList.insert(rssFeed, at: 0)
    }
    func addLikeFeedItem(_ likeFeedItem: RNRssFeedItem) {
        guard let jsonObj = likeFeedItem.yy_modelToJSONObject() else {
            return
        }
        insertReadNode(array: jsonObj as! [String: Any], isLike: true)
        likeRssFeedItemList.insert(likeFeedItem, at: 0)
    }
    func removeRssFeed(_ link: String) {
        removeReadNode(link: link, isLike: false)
    }
    func removeLikeFeedItem(_ link: String) {
        removeReadNode(link: link, isLike: true)
        loadLikeFeedItem()
    }
    func updateRssFeed(_ rssFeed: RNRssFeed) {
        guard let jsonObj = rssFeed.yy_modelToJSONObject() else {
            return
        }
        updateReadNode(array: jsonObj as! [String: Any])
        loadReadNode()
    }
 
    /// 数据库队列
    let queue: FMDatabaseQueue
    /// 数据库喜欢队列
    let likeQueue: FMDatabaseQueue
    private init() {
        queue = FMDatabaseQueue(path: rnDBPath)
        // 创建数据库队列
        likeQueue = FMDatabaseQueue(path: likeDBpath)
        createTable()
        loadReadNode()
        loadLikeFeedItem()
    }
}
// MARK: - 数据操作
private extension RNSQLiteManager {
    
    func loadReadNode() {
        rssFeedList.removeAll()
        var sql = "SELECT id, link, rssFeed FROM T_ReadNode \n"
        sql += "ORDER BY id DESC;"
        let array = execRecordSet(sql: sql, isLike: false)
        for dict in array {
            guard let jsonData = dict["rssFeed"] as? Data, let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
                continue
            }
            let rssFeed = RNRssFeed()
            rssFeed.yy_modelSet(with: json!)
            rssFeedList.append(rssFeed)
        }
    }
    func loadLikeFeedItem() {
        likeRssFeedItemList.removeAll()
        var sql = "SELECT id, link, likeFeedItem FROM T_LikeReadNode \n"
        sql += "ORDER BY id DESC;"
        let array = execRecordSet(sql: sql, isLike: true)
        for dict in array {
            guard let jsonData = dict["likeFeedItem"] as? Data, let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
                continue
            }
            let feedItem = RNRssFeedItem()
            feedItem.yy_modelSet(with: json!)
            likeRssFeedItemList.append(feedItem)
        }
    }
    func insertReadNode(array: [String: Any], isLike: Bool) {
        var sql = "INSERT OR REPLACE INTO T_ReadNode (link, rssFeed) VALUES (?, ?);"
        var inQueue = queue
        var link = "link"
        if isLike {
            sql = "INSERT OR REPLACE INTO T_LikeReadNode (link, likeFeedItem) VALUES (?, ?);"
            inQueue = likeQueue
            link = "itemLink"
        }
        inQueue.inTransaction { (db, rollback) in
            
            guard let link = array[link] as? String, let jsonData = try? JSONSerialization.data(withJSONObject: array, options: []) else {
                return
            }
            if db.executeUpdate(sql, withArgumentsIn: [link, jsonData]) == false {
                rollback.pointee = true
            }
        }
    }
    func updateReadNode(array: [String: Any]) {
        let sql = "UPDATE T_ReadNode SET rssFeed = (?) WHERE link = (?);"
        queue.inTransaction { (db, rollback) in
            guard let link = array["link"] as? String, let jsonData = try? JSONSerialization.data(withJSONObject: array, options: []) else {
                return
            }
            if db.executeUpdate(sql, withArgumentsIn: [jsonData, link]) == false {
                rollback.pointee = true
            }
        }
    }
    func removeReadNode(link: String, isLike: Bool) {
        var sql = "DELETE FROM T_ReadNode WHERE link = (?)"
        var inQueue = queue
        if isLike {
            sql = "DELETE FROM T_LikeReadNode WHERE link = (?)"
            inQueue = likeQueue
        }
        inQueue.inTransaction { (db, rollback) in
            if db.executeUpdate(sql, withArgumentsIn: [link]) == false {
                rollback.pointee = true
            }
        }
    }
}
// MARK: - 创建数据库表以及其他私有方法
private extension RNSQLiteManager {
    
    func execRecordSet(sql: String, isLike: Bool) -> [[String: Any]] {
        var result = [[String: Any]]()
        var inQueue = queue
        if isLike {
           inQueue = likeQueue
        }
        inQueue.inDatabase { (db) in
            guard let rs = db.executeQuery(sql, withArgumentsIn: []) else {
                return
            }
            while rs.next() {
                let colCount = rs.columnCount
                for col in 0..<colCount {
                    guard let name = rs.columnName(for: col), let value = rs.object(forColumnIndex: col) else {
                        continue
                    }
                    result.append([name: value])
                }
            }
        }
        return result
    }
    /// 创建数据库
    func createTable() {
        guard let readNodePath = Bundle.main.path(forResource: "ReadNode.sql", ofType: nil), let likeReadNodePath = Bundle.main.path(forResource: "LikeReadNode.sql", ofType: nil), let sql = try? String(contentsOfFile: readNodePath), let likeSql = try? String(contentsOfFile: likeReadNodePath) else {
            return
        }
        // 执行sql FMDB内部队列 串行队列 同步执行
        queue.inDatabase { (db) in
            if db.executeStatements(sql) == true {
                print("创表成功")
            } else {
                print("创表失败")
            }
        }
        likeQueue.inDatabase { (db) in
            if db.executeStatements(likeSql) == true {
                print("创Like表成功")
            } else {
                print("创Like表失败")
            }
        }
    }
    
}
