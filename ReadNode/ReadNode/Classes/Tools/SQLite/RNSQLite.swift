//
//  RNSQLite.swift
//  ReadNode
//
//  Created by ntian on 2017/8/17.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit
import YYModel

class RNSQLite {
    
    private init() {}
    static let shared = RNSQLite()
    lazy var rssFeedList = [RNRssFeed]()

    func saveRssFeed(_ rssFeed: RNRssFeed) {
        rssFeedList.insert(rssFeed, at: 0)
        print(rssFeed.link)

    }
}
