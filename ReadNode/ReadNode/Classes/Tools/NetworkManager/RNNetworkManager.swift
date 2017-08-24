//
//  RNNetworkManager.swift
//  ReadNode
//
//  Created by ntian on 2017/8/11.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit
import Alamofire

class RNNetworkManager {
    
    private init() {}
    // 创建单例
    static let shared = RNNetworkManager()

    func request(urlString: String, completion: @escaping (_ rssFeed: RNRssFeed?, _ isSuccess: Bool) -> ()) {
        guard let url = URL(string: urlString) else {
            completion(nil, false)
            return
        }
        Alamofire.request(url).responseRSS { (response) in
            if response.result.isFailure {
                completion(nil, false)
                return
            }
            let feed = response.result.value
            if feed?.items.count == 0 {
                completion(nil, false)
                return
            }
            var rssFeedItems = [RNRssFeedItem]()
            for item in (feed?.items)! {
                rssFeedItems.append(RNRssFeedItem(title: item.title, author: feed?.title, link: feed?.link, itemLink: item.link, itemDescription: item.itemDescription, pubDate: item.pubDate))
            }
            let rssFeed = RNRssFeed(title: feed?.title, link: feed?.link, feedDescription: feed?.feedDescription, pubDate: feed?.pubDate, items: rssFeedItems)
            RNSQLiteManager.shared.addRssFeed(rssFeed)
            completion(rssFeed, true)
        }
    }
}
