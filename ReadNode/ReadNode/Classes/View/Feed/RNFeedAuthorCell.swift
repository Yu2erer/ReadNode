//
//  RNFeedAuthorCell.swift
//  ReadNode
//
//  Created by ntian on 2017/8/10.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit

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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 离屏渲染
        self.layer.drawsAsynchronously = true
        // 栅格化
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }

}
