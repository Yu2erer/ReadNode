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
    @objc var title: String?
    /// 链接
    @objc var itemLink: String?
    /// 主页面
    @objc var link: String?
    /// 描述
    @objc var itemDescription: String?
    /// 发布时间
    @objc var pubDate: Date?
    /// 是否喜欢
    @objc var isLike: Bool = false
    /// 作者名
    @objc var author: String?
    /// 图片数组
    @objc var imagesFromDescription: [String]?
    /// 图标图片地址
    @objc var iconLink: String?
    
    init(title: String?, author: String?, link: String?, itemLink: String?, itemDescription: String?, pubDate: Date?, imagesFromDescription: [String]?) {
        self.title = title
        self.author = author
        self.link = link
        self.itemLink = itemLink
        self.itemDescription = itemDescription
        self.pubDate = pubDate
        self.imagesFromDescription = imagesFromDescription
        iconLink = "http://yuerer.com/favicon/?domain=\(self.link ?? "")"
    }
    override init() {}
    override var description: String {
        return "title:\(title ?? "")\nitemlink:\(itemLink ?? "")\nitemDescription:\(itemDescription ?? "")pubDate:\(String(describing: pubDate))"
    }
}
