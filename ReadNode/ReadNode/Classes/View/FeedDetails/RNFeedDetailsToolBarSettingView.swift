//
//  RNFeedDetailsToolBarSettingView.swift
//  ReadNode
//
//  Created by ntian on 2017/9/4.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit

@objc enum segmentStatus: Int {
    case small = 0
    case middle = 1
    case big = 2
}
@objc protocol RNFeedDetailsToolBarSettingViewDelegate: NSObjectProtocol {
    @objc optional func didChangeFontSize(_ segmentStatus: segmentStatus)
}
class RNFeedDetailsToolBarSettingView: UIView {
    @IBOutlet weak private var segmentControl: UISegmentedControl!
    var segmentIndex: segmentStatus = .middle {
        didSet {
            segmentControl.selectedSegmentIndex = segmentIndex.rawValue
        }
    }
    weak var settingViewDelegate: RNFeedDetailsToolBarSettingViewDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.white
        segmentControl.selectedSegmentIndex = segmentIndex.rawValue
    }
    @IBAction private func changeControl(_ sender: UISegmentedControl) {
        settingViewDelegate?.didChangeFontSize?(segmentStatus(rawValue: sender.selectedSegmentIndex)!)
    }
    class func toolBarSettingView() -> RNFeedDetailsToolBarSettingView {
        let nib = UINib(nibName: "RNFeedDetailsToolBarSettingView", bundle: nil)
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! RNFeedDetailsToolBarSettingView
        return v
    }
}
