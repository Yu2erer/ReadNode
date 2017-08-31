//
//  UIButton+Extensions.swift
//  ReadNode
//
//  Created by ntian on 2017/8/31.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit

extension UIButton {
    
    class func nt_textButton(title: String, font: UIFont? = nil) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = font
        button.sizeToFit()
        return button
    }
}
