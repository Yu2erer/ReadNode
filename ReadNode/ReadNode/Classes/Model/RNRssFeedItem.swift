//
//  RNRssFeedItem.swift
//  ReadNode
//
//  Created by ntian on 2017/8/16.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit

class RNRssFeedItem: NSObject {

    /// 标题
    var title: String?
    /// 链接
    var link: String?
    /// 描述
    var itemDescription: String?
    /// 发布时间
    var pubDate: Date?
    
    init(title: String?, link: String?, itemDescription: String?, pubDate: Date?) {
        self.title = title
        self.link = link
        self.itemDescription = itemDescription
        self.pubDate = pubDate
    }
    override var description: String {
        return "title:\(title ?? "")\nlink:\(link ?? "")\nitemDescription:\(itemDescription ?? "")pubDate:\(String(describing: pubDate))"
    }
}
