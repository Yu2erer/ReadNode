//
//  RNAuthorFeedDetailsCell.swift
//  ReadNode
//
//  Created by ntian on 2017/8/20.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit
import SwipeCellKit

@objc protocol RNAuthorFeedDetailsCellDelegate: NSObjectProtocol {
    @objc optional func didClickStatus(item: RNRssFeedItem)
}
class RNAuthorFeedDetailsCell: SwipeTableViewCell {
    
    @IBOutlet weak var separatorView: UIView!
    /// 正文标签
    @IBOutlet fileprivate weak var statusLabel: UILabel!
    /// 时间标签
    @IBOutlet fileprivate weak var timeLabel: UILabel!
    /// 作者正文标签点击
    fileprivate var statusTouch = false
    weak var detailsCellDelegate: RNAuthorFeedDetailsCellDelegate?

    var model: RNRssFeedItem? {
        didSet {
            
            statusLabel.text = model?.title
            timeLabel.text = model?.pubDate?.nt_dateDescription
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // 离屏渲染
        self.layer.drawsAsynchronously = true
        // 栅格化
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.nt_screenScale
    }
}
// MARK: - Touch
extension RNAuthorFeedDetailsCell {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.statusTouch = false
        let t = (touches as NSSet).anyObject() as! UITouch
        let p = t.location(in: statusLabel)
        if (statusLabel.bounds).contains(p) && statusLabel.bounds.width > p.x {
            self.statusTouch = true
        } else {
            super.touchesBegan(touches, with: event)
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !statusTouch {
            super.touchesEnded(touches, with: event)
        } else {
            statusTouch ? detailsCellDelegate?.didClickStatus?(item: model!) : ()
        }
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
    }
}
