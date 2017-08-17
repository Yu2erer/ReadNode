//
//  RNRssFeed.swift
//  ReadNode
//
//  Created by ntian on 2017/8/11.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit

class RNRssFeed: NSObject {
    
    /// 文章标题
    var title: String?
    /// 主页面
    var link: String?
    /// 最近更新日期
    var pubDate: Date?
    /// 作者Rss描述
    var feedDescription: String?
    /// Rss详细Item
    var items: [RNRssFeedItem]?
    /// 图标图片地址
    var iconLink: String?
    
    init(title: String?, link: String?, feedDescription: String?, pubDate: Date?, items: [RNRssFeedItem]?) {
        self.title = title
        self.link = link
        self.feedDescription = feedDescription
        self.pubDate = pubDate
        self.items = items
        // init 方法不调用 didSet 
        iconLink = "http://www.google.com/s2/favicons?domain=\(self.link ?? "")"
    }
    override var description: String {
        return "title:\(title)\nlink:\(link)\nfeedDescription:\(feedDescription)\npubDate:\(pubDate)\nitems:\(items)"
    }
}
