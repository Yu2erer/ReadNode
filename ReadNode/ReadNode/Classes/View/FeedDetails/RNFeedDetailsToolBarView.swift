//
//  RNFeedDetailsToolBarView.swift
//  ReadNode
//
//  Created by ntian on 2017/9/3.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit

@objc protocol RNFeedDetailsToolBarDelegate: NSObjectProtocol {
    @objc optional func didClickBack()
}
class RNFeedDetailsToolBarView: UIView {

    weak var toolBarDelegate: RNFeedDetailsToolBarDelegate?
    
    class func toolBarView() -> RNFeedDetailsToolBarView {
        let nib = UINib(nibName: "RNFeedDetailsToolBarView", bundle: nil)
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! RNFeedDetailsToolBarView
        return v
    }
    @IBAction func back(_ sender: UIButton) {
        toolBarDelegate?.didClickBack?()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.white
    }
}
