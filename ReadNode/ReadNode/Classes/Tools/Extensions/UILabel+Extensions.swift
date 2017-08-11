//
//  UILabel+Extensions.swift
//  ReadNode
//
//  Created by ntian on 2017/8/11.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit

extension UILabel {
    
    /// 创建一个 titleView
    ///
    /// - Parameters:
    ///   - text: 文本内容
    ///   - textColor: 文本颜色
    ///   - font: 文本字体
    /// - Returns: UILabel
    class func titleView(text: String, textColor: UIColor? = UIColor.black, font: UIFont? = nil) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = textColor
        label.font = font
        label.sizeToFit()
        return label
    }
}
