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
    @objc optional func didClickLike()
}
class RNFeedDetailsToolBarView: UIView {

    @IBOutlet weak var likeBtn: UIButton!
    weak var toolBarDelegate: RNFeedDetailsToolBarDelegate?
    var isLike: Bool? = false {
        didSet {
            if isLike! {
                likeBtn.setImage(UIImage(named: "toolbar-unfav"), for: .normal)
                likeBtn.setImage(UIImage(named: "toolbar-unfav-highlight"), for: .highlighted)
            } else {
                likeBtn.setImage(UIImage(named: "toolbar-fav"), for: .normal)
                likeBtn.setImage(UIImage(named: "toolBar-fav-highlight"), for: .highlighted)
            }
        }
    }
    class func toolBarView() -> RNFeedDetailsToolBarView {
        let nib = UINib(nibName: "RNFeedDetailsToolBarView", bundle: nil)
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! RNFeedDetailsToolBarView
        return v
    }
    @IBAction func like(_ sender: UIButton) {
        toolBarDelegate?.didClickLike?()
    }
    @IBAction func back(_ sender: UIButton) {
        toolBarDelegate?.didClickBack?()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.white
    }
}
