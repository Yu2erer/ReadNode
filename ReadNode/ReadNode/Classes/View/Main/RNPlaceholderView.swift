//
//  RNPlaceholderView.swift
//  ReadNode
//
//  Created by ntian on 2017/8/30.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit

class RNPlaceholderView: UIView {

    private lazy var iconView = UIImageView(image: UIImage(named: "feedPlaceholder"))
    private lazy var tipLabel = UILabel.nt_label(text: "Add Rss Feed now.", textColor: UIColor.nt_color(hex: 0x999999), font: UIFont.systemFont(ofSize: 12))
    private lazy var button = UIButton.nt_textButton(title: "Go to Discover Tab Bar", font: UIFont.systemFont(ofSize: 14))
    var placeholderInfo: [String: String]? {
        didSet {
            guard let imageName = placeholderInfo?["imageName"], let message = placeholderInfo?["message"] else {
                return
            }
            iconView.image = UIImage(named: imageName)
            tipLabel.text = message
        }
    }
    // 按钮回调
    var completionCallBack: (() -> ())? {
        didSet {
            button.isHidden = false
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc private func btnTouchup() {
        completionCallBack?()
    }

}
// MARK: - UI
extension RNPlaceholderView {
    private func setupUI() {
        backgroundColor = UIColor.white
     
        addSubview(iconView)
        addSubview(tipLabel)
        addSubview(button)
        button.addTarget(self, action: #selector(btnTouchup), for: .touchUpInside)
        button.isHidden = true
        tipLabel.textAlignment = .center
        for v in subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        // iconView
        addConstraint(NSLayoutConstraint(item: iconView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: iconView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: -140))
        // tipLabel
        addConstraint(NSLayoutConstraint(item: tipLabel, attribute: .centerX, relatedBy: .equal, toItem: iconView, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: tipLabel, attribute: .top, relatedBy: .equal, toItem: iconView, attribute: .bottom, multiplier: 1.0, constant: 28))
        addConstraint(NSLayoutConstraint(item: tipLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 236))
        // button
        addConstraint(NSLayoutConstraint(item: button, attribute: .centerX, relatedBy: .equal, toItem: iconView, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: tipLabel, attribute: .bottom, multiplier: 1.0, constant: 28))
        
    }
}
