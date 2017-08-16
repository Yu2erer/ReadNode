//
//  NTMessageHud.swift
//
//  Created by ntian on 2017/4/25.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit

class NTMessageHud {
    
    class func showMessage(message: String?) {
        
        let view = UIView()
        let label = UILabel(frame: CGRect(x: 15, y: 25, width: 290, height: 30))
        label.text = message
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.nt_color(hex: 0x3E4354)

        view.addSubview(label)
        view.frame.size.width = UIScreen.main.bounds.width
        view.frame.size.height = 64
        view.frame.origin.y = -64
        
        view.backgroundColor = UIColor.nt_color(hex: 0xFAFCFF)
        let targetView = UIApplication.shared.windows.last ?? UIApplication.shared.keyWindow
        
        targetView?.addSubview(view)
        UIView.animate(withDuration: 0.3, animations: {
            view.frame.origin.y = 0
        }) { (_) in
            UIView.animate(withDuration: 0.2, delay: 2, options: .curveEaseInOut, animations: {
                view.frame.origin.y = -64
            }, completion: { (_) in
                view.removeFromSuperview()
            })
        }
    }
}
