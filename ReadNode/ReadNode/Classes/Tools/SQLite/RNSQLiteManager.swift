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
        insertReadNode(array: jsonObj as! [String: Any])
        rssFeedList.insert(rssFeed, at: 0)
    }
    func removeRssFeed(_ link: String) {
        removeReadNode(link: link)
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
    
    private init() {
        // 数据库全路径
        let dbName = "ReadNode.db"
        var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        path = (path as NSString).appendingPathComponent(dbName)
        print(path)
        // 创建数据库队列
        queue = FMDatabaseQueue(path: path)
        createTable()
        loadReadNode()
    }
}
// MARK: - 数据操作
private extension RNSQLiteManager {
    
    func loadReadNode() {
        rssFeedList.removeAll()
        var sql = "SELECT id, link, rssFeed FROM T_ReadNode \n"
        sql += "ORDER BY id DESC;"
        let array = execRecordSet(sql: sql)
        for dict in array {
            guard let jsonData = dict["rssFeed"] as? Data, let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
                continue
            }
            let rssFeed = RNRssFeed()
            rssFeed.yy_modelSet(with: json!)
            rssFeedList.append(rssFeed)
            guard let items = json?["items"] as? [[String: Any]] else {
                continue
            }
            for item in items {
                let isLike = item["isLike"] as? Bool
                if isLike == true {
                    let rssFeedItem = RNRssFeedItem()
                    rssFeedItem.yy_modelSet(with: item)
                    likeRssFeedItemList.append(rssFeedItem)
                }
            }
        }
    }
    func insertReadNode(array: [String: Any]) {
        let sql = "INSERT OR REPLACE INTO T_ReadNode (link, rssFeed) VALUES (?, ?);"
        queue.inTransaction { (db, rollback) in
            
            guard let link = array["link"] as? String, let jsonData = try? JSONSerialization.data(withJSONObject: array, options: []) else {
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
    func removeReadNode(link: String) {
        let sql = "DELETE FROM T_ReadNode WHERE link = (?)"
        queue.inTransaction { (db, rollback) in
            if db.executeUpdate(sql, withArgumentsIn: [link]) == false {
                rollback.pointee = true
            }
        }
    }
}
// MARK: - 创建数据库表以及其他私有方法
private extension RNSQLiteManager {
    
    func execRecordSet(sql: String) -> [[String: Any]] {
        var result = [[String: Any]]()
        
        queue.inDatabase { (db) in
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
        guard let path = Bundle.main.path(forResource: "ReadNode.sql", ofType: nil), let sql = try? String(contentsOfFile: path) else {
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
    }
    
}
