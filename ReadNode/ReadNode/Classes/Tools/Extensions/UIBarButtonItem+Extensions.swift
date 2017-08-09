//
//  UIBarButtonItem+Extensions.swift
//  ReadNode
//
//  Created by ntian on 2017/8/9.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    // 便利构造函数 创建 带图像的 BarButton
    convenience init(imageName: String, target: Any?, action: Selector) {
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), for: .normal)
        btn.sizeToFit()
        btn.addTarget(target, action: action, for: .touchUpInside)
        self.init(customView: btn)
    }
}
