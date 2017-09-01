//
//  UIColor+Extensions.swift
//
//  Created by ntian on 2017/7/17.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit

extension UIColor {
    
    class func nt_color(hex: UInt) -> UIColor {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(hex & 0x0000FF) / 255.0
        return UIColor.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
    class func nt_randomColor() -> UIColor {
        let randomFloat =  CGFloat(arc4random_uniform(256)) / 255.0
        return UIColor.init(red: randomFloat, green: randomFloat, blue: randomFloat, alpha: 1.0)
    }

}
