//
//  RNCloudKitManager.swift
//  ReadNode
//
//  Created by ntian on 2017/9/5.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit
import CloudKit

class RNCloudKitManager {
    
    private init() { }
    static let shared = RNCloudKitManager()
    
    func save(fileUrlString: String, recordName: String, completion: @escaping (_ error: Error?)->()) {
        let url = URL(fileURLWithPath: fileUrlString)
        let assert = CKAsset(fileURL: url)
        let recoreId = CKRecordID(recordName: recordName)
        let record = CKRecord(recordType: "SQL", recordID: recoreId)
        record.setValue(assert, forKey: recordName)
        CKContainer.default().publicCloudDatabase.save(record) { (saveRecord, error) in
            print(saveRecord?.allKeys())
            completion(error)
        }
    }
    func delete(recordName: String, completion: @escaping (_ error: Error?)->()) {
        let recordId = CKRecordID(recordName: recordName)
        CKContainer.default().publicCloudDatabase.delete(withRecordID: recordId) { (deleteRecord, error) in
            completion(error)
        }
    }
    func fetch(recordName: String) {
        let recordId = CKRecordID(recordName: recordName)
        CKContainer.default().publicCloudDatabase.fetch(withRecordID: recordId) { (record, error) in
            print(record)
//            try? FileManager.default.moveItem(at: data.fileURL, to: url)
//            print(data.fileURL)
            
        }


    }
    
    
}
