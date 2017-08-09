//
//  UIColor+Extensions.swift
//
//  Created by ntian on 2017/7/17.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit

extension UIColor {
    
    class func nt_color(hex: UInt) -> UIColor {
        let red = Float((hex & 0xFF0000) >> 16) / 255.0
        let green = Float((hex & 0x00FF00) >> 8) / 255.0
        let blue = Float(hex & 0x0000FF) / 255.0
        return UIColor(colorLiteralRed: Float(red), green: Float(green), blue: Float(blue), alpha: 1.0)
    }
    class func nt_randomColor() -> UIColor {
        let randomFloat =  Float(arc4random_uniform(256)) / 255.0
        return UIColor(colorLiteralRed: randomFloat, green: randomFloat, blue: randomFloat, alpha: 1.0)
    }

}
