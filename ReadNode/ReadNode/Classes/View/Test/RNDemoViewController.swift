//
//  RNDemoViewController.swift
//  ReadNode
//
//  Created by ntian on 2017/8/9.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit
import CloudKit

class RNDemoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        let recordId = CKRecordID(recordName: "template")

//        let dbName = "ReadNode.db"
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let writePath = (path as NSString).appendingPathComponent("xx.db")
//        let dbPath = (path as NSString).appendingPathComponent(dbName)
//////        let url = URL(string: dbPath)
        let url = URL(fileURLWithPath: writePath)
//        let url = URL(fileURLWithPath: dbPath)
//        let assert = CKAsset(fileURL: url)
//        let record = CKRecord(recordType: "template", recordID: recordId)
//        record.setValue(assert, forKey: "template")
//        CKContainer.default().publicCloudDatabase.save(record) { (saveRecord, error) in
//            print(saveRecord?.allKeys())
//            print(error.debugDescription)
//        }

        CKContainer.default().publicCloudDatabase.fetch(withRecordID: recordId) { (record, error) in
            
            let data = record?["template"] as! CKAsset
            
            //            _ = try! data?.write(to: url)
            
//            print(record?["template"])
//            try? FileManager.default.moveItem(at: data.fileURL, to: url)
//            print(data.fileURL)
        }
        CKContainer.default().publicCloudDatabase.delete(withRecordID: recordId) { (record, error) in
            
        }
    }
}
