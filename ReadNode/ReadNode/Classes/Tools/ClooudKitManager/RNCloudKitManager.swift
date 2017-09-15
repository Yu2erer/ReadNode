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
    
    func save(fileUrlString: String, recordName: String, completion: @escaping (_ isSuccess: Bool)->()) {
        let url = URL(fileURLWithPath: fileUrlString)
        let assert = CKAsset(fileURL: url)
        let recoreId = CKRecordID(recordName: recordName)
        let record = CKRecord(recordType: "SQL", recordID: recoreId)
        record.setValue(assert, forKey: recordName)
        CKContainer.default().publicCloudDatabase.save(record) { (saveRecord, error) in
            if error != nil {
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    func delete(recordName: String, completion: @escaping (_ isSuccess: Bool)->()) {
        let recordId = CKRecordID(recordName: recordName)
        CKContainer.default().publicCloudDatabase.delete(withRecordID: recordId) { (deleteRecord, error) in
            if error != nil {
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    func fetch(recordName: String, move to: String, completion: @escaping (_ isSuccess: Bool, _ errorCode: Int?) -> ()) {
        let recordId = CKRecordID(recordName: recordName)
        CKContainer.default().publicCloudDatabase.fetch(withRecordID: recordId) { (record, error) in
            let ckError = error as? CKError
            if error != nil {
                completion(false, ckError?.errorCode)
                return
            }
            guard let data = record?[recordName] as? CKAsset else {
                completion(false, nil)
                return
            }
            let url = URL(fileURLWithPath: to)
            do {
                if FileManager.default.fileExists(atPath: to) {
                    try FileManager.default.removeItem(atPath: to)
                }
                try FileManager.default.moveItem(at: data.fileURL, to: url)
            } catch {
                completion(false, nil)
                print(error)
                return
            }
            completion(true, nil)
        }
    }
    func accountStatus(completion: @escaping (_ isAvailable: Bool) -> ()) {
        CKContainer.default().accountStatus { (status, error) in
            if status == .noAccount || status == .couldNotDetermine || status == .restricted {
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    
}
