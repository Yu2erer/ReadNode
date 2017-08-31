//
//  RNLikeTableViewCell.swift
//  ReadNode
//
//  Created by ntian on 2017/8/31.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit
import SwipeCellKit

@objc protocol RNLikeTableViewCellDelegate: NSObjectProtocol {
    @objc optional func didClickStatus(item: RNRssFeedItem)
}

class RNLikeTableViewCell: SwipeTableViewCell {

    /// 正文
    @IBOutlet fileprivate weak var statusLabel: UILabel!
    /// 时间
    @IBOutlet fileprivate weak var timeLabel: UILabel!
    /// 作者
    @IBOutlet fileprivate weak var authorLabel: UILabel!
    /// RSS图标
    @IBOutlet fileprivate weak var iconView: UIImageView!
    /// 分割线
    @IBOutlet weak var separatorView: UIView!
    /// 作者正文标签点击
    fileprivate var statusTouch = false
    weak var likeCellDelegate: RNLikeTableViewCellDelegate?
    var model: RNRssFeedItem? {
        didSet {
            authorLabel.text = model?.author
            statusLabel.text = model?.title
            iconView.nt_setAvatarImage(urlString: model?.iconLink ?? "http://yuerer.com/favicon/?domain=\(model?.link ?? "")", placeholder: nil, isAvator: true)
            timeLabel.text = model?.pubDate?.nt_dateDescription ?? " "
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
// MARK: - 点击事件
extension RNLikeTableViewCell {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.statusTouch = false
        if self.isEditing {
            return
        }
        let t: UITouch = (touches as NSSet).anyObject() as! UITouch
        let p = t.location(in: statusLabel)
        if (statusLabel.bounds).contains(p) && statusLabel.bounds.width > p.x {
            self.statusTouch = true
        }
        if !statusTouch {
            super.touchesBegan(touches, with: event)
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !statusTouch {
            super.touchesEnded(touches, with: event)
        } else {
            statusTouch ? likeCellDelegate?.didClickStatus?(item:             (model)!) : ()
        }
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !statusTouch {
            super.touchesCancelled(touches, with: event)
        }
    }
}
