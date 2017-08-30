//
//  RNPlaceholderView.swift
//  ReadNode
//
//  Created by ntian on 2017/8/30.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit

class RNPlaceholderView: UIView {

    fileprivate lazy var iconView = UIImageView(image: UIImage(named: "likePlaceholder"))
    fileprivate lazy var tipLabel = UILabel.titleView(text: "当前列表为空", textColor: UIColor.nt_color(hex: 0x999999), font: UIFont.systemFont(ofSize: 12))
    
    var placeholderInfo: [String: String]? {
        didSet {
            guard let imageName = placeholderInfo?["imageName"], let message = placeholderInfo?["message"] else {
                return
            }
            iconView.image = UIImage(named: imageName)
            tipLabel.text = message
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
// MARK: - UI
extension RNPlaceholderView {
    fileprivate func setupUI() {
        backgroundColor = UIColor.white
        
        addSubview(iconView)
        addSubview(tipLabel)
        tipLabel.textAlignment = .center
        for v in subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        // iconView
        addConstraint(NSLayoutConstraint(item: iconView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: iconView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: -140))
        // tipLabel
        addConstraint(NSLayoutConstraint(item: tipLabel, attribute: .centerX, relatedBy: .equal, toItem: iconView, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: tipLabel, attribute: .top, relatedBy: .equal, toItem: iconView, attribute: .bottom, multiplier: 1.0, constant: 30))
        addConstraint(NSLayoutConstraint(item: tipLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 236))
    }
}
