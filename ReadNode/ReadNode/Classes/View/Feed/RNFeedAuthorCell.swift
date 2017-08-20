//
//  RNFeedAuthorCell.swift
//  ReadNode
//
//  Created by ntian on 2017/8/10.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit
import Kingfisher

@objc protocol RNFeedAuthorCellDelegate: NSObjectProtocol {
    @objc optional func didClickAuthor(model: RNRssFeed)
    @objc optional func didClickStatus(item: RNRssFeedItem)
}

class RNFeedAuthorCell: UITableViewCell {

    /// RSS图标 favicon
    @IBOutlet weak var iconView: UIImageView!
    /// 作者名称
    @IBOutlet weak var authorLabel: UILabel!
    /// 正文
    @IBOutlet weak var statusLabel: UILabel!
    /// 最后更新时间
    @IBOutlet weak var timeLabel: UILabel!
    /// 文章总数
    @IBOutlet weak var countLabel: UILabel!
    /// 作者标签点击
    var authorTouch = false
    /// 作者正文标签点击
    var statusTouch = false
    weak var authorCellDelegate: RNFeedAuthorCellDelegate?
    var model: RNRssFeed? {
        didSet {
            authorLabel.text = model?.title
            statusLabel.text = model?.items?.first?.title
            countLabel.text = "\(model?.items?.count ?? 0)"
            iconView.nt_setAvatarImage(urlString: model?.iconLink, placeholder: nil, isAvator: true)
            timeLabel.text = model?.pubDate?.nt_dateDescription ?? " "
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 离屏渲染
        self.layer.drawsAsynchronously = true
        // 栅格化
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }

}
// MARK: - 点击事件
extension RNFeedAuthorCell {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.authorTouch = false
        self.statusTouch = false
        
        let t: UITouch = (touches as NSSet).anyObject() as! UITouch
        var p = t.location(in: authorLabel)
        if (authorLabel.bounds).contains(p) && authorLabel.bounds.width > p.x {
            self.authorTouch = true
        }
        p = t.location(in: iconView)
        if (iconView.bounds).contains(p) {
            self.authorTouch = true
        }
        p = t.location(in: statusLabel)
        if (statusLabel.bounds).contains(p) && statusLabel.bounds.width > p.x {
            self.statusTouch = true
        }
        if !authorTouch || !statusTouch {
            super.touchesBegan(touches, with: event)
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !authorTouch && !statusTouch {
            super.touchesEnded(touches, with: event)
        } else {
            authorTouch ? authorCellDelegate?.didClickAuthor?(model: model!) : ()
            statusTouch ? authorCellDelegate?.didClickStatus?(item:             (model?.items?.first)!) : ()
        }
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !authorTouch || !statusTouch {
            super.touchesCancelled(touches, with: event)
        }
    }
}
