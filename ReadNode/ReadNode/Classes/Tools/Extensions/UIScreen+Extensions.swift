//
//  UIScreen+Extensions.swift
//  extensions
//
//  Created by ntian on 2017/7/17.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit

extension UIScreen {
    
    class var nt_screenWidth: CGFloat {
        return UIScreen.main.bounds.size.width
    }
    class var nt_screenHeight: CGFloat {
        return UIScreen.main.bounds.size.height
    }
    class var nt_screenScale: CGFloat {
        return UIScreen.main.scale
    }
}
