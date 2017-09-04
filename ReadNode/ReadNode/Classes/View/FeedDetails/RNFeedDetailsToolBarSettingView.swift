//
//  RNFeedDetailsToolBarSettingView.swift
//  ReadNode
//
//  Created by ntian on 2017/9/4.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit

class RNFeedDetailsToolBarSettingView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.white
    }
    class func toolBarSettingView() -> RNFeedDetailsToolBarSettingView {
        let nib = UINib(nibName: "RNFeedDetailsToolBarSettingView", bundle: nil)
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! RNFeedDetailsToolBarSettingView
        return v
    }
}
