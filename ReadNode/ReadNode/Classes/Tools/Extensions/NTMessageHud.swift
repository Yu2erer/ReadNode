//
//  NTMessageHud.swift
//
//  Created by ntian on 2017/4/25.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit

class NTMessageHud {
    
    class func showMessage(message: String) {
        
        let label = UILabel()
        label.text = message
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.frame.size.width = UIScreen.main.bounds.width
        label.frame.size.height = 64
        label.frame.origin.y = -64
        
        label.backgroundColor = UIColor.nt_color(hex: 0xFAFCFF)
        let targetView = UIApplication.shared.windows.last ?? UIApplication.shared.keyWindow
        
        targetView?.addSubview(label)
        UIView.animate(withDuration: 0.3, animations: {
            label.frame.origin.y = 0
        }) { (_) in
            UIView.animate(withDuration: 0.2, delay: 2, options: .curveEaseInOut, animations: {
                label.frame.origin.y = -64
            }, completion: { (_) in
                label.removeFromSuperview()
            })
        }
    }
}
