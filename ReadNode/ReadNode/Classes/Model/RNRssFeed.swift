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
    @objc var title: String?
    /// 主页面
    @objc var link: String?
    /// 最近更新日期
    @objc var pubDate: Date?
    /// 作者Rss描述
    @objc var feedDescription: String?
    /// Rss详细Item
    @objc var items: [RNRssFeedItem]?
    /// 图标图片地址
    @objc var iconLink: String?
    /// feedLink 更新用
    @objc var feedLink: String?
    
    init(title: String?, link: String?, feedLink: String?, feedDescription: String?, pubDate: Date?, items: [RNRssFeedItem]?) {
        self.title = title
        self.link = link
        self.feedLink = feedLink
        self.feedDescription = feedDescription
        self.pubDate = pubDate
        self.items = items
        // init 方法不调用 didSet 
        iconLink = "http://yuerer.com/favicon/?domain=\(self.link ?? "")"
    }
    override init() { }
    override var description: String {
        return "title:\(title ?? "")\nlink:\(link ?? "")\nfeedDescription:\(feedDescription ?? "")\npubDate:\(String(describing: pubDate))\nitems:\(String(describing: items))"
    }
    @objc class func modelContainerPropertyGenericClass() -> [String: Any] {
        return ["items": RNRssFeedItem.self]
    }
}
