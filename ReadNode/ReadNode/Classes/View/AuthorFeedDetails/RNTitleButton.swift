//
//  RNTitleButton.swift
//  ReadNode
//
//  Created by ntian on 2017/8/20.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit

class RNTitleButton: UIButton {

    init(title: String, imageUrlString: String?) {
        super.init(frame: CGRect())
        setTitle(" " + title, for: .normal)
        let url = URL(string: imageUrlString!)!
        imageView?.bounds.size = CGSize(width: 16, height: 16)
        imageView?.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil, completionHandler: { (image, _, _, _) in
            self.setImage(image?.nt_acatarImage(size: image?.size), for: .normal)
            self.sizeToFit()
        })
        titleLabel?.font = UIFont(name: "PingFang", size: 12)
        setTitleColor(UIColor.nt_color(hex: 0x34394B), for: .normal)
        self.sizeToFit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
