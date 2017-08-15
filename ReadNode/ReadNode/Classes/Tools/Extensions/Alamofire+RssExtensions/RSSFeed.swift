//
//  RSSFeed.swift
//  AlamofireRSSParser
//
//  Created by Donald Angelillo on 3/1/16.
//  Copyright © 2016 Donald Angelillo. All rights reserved.
//

import Foundation

/**
    RSS gets deserialized into an instance of `RSSFeed`.  Top-level RSS elements are housed here.
    
    Item-level elements are deserialized into `RSSItem` objects and stored in the `items` property.
*/
open class RSSFeed: CustomStringConvertible {
    open var title: String? = nil
    open var link: String? = nil
    open var feedDescription: String? = nil
    open var pubDate: Date? = nil
    open var lastBuildDate: Date? = nil
    open var language: String? = nil
    open var copyright: String? = nil
    open var managingEditor: String? = nil
    open var webMaster: String? = nil
    open var generator: String? = nil
    open var docs: String? = nil
    open var ttl: NSNumber? = nil
    
    open var items: [RSSItem] = Array()
    
    open var description: String {
        return "title: \(self.title)\nfeedDescription: \(self.feedDescription)\nlink: \(self.link)\npubDate: \(self.pubDate)\nlastBuildDate: \(self.lastBuildDate)\nlanguage: \(self.language)\ncopyright: \(self.copyright)\nmanagingEditor: \(self.managingEditor)\nwebMaster: \(self.webMaster)\ngenerator: \(self.generator)\ndocs: \(self.docs)\nttl: \(self.ttl)\nitems: \n\(self.items)"
    }
    
}
