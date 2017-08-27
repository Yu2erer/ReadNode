//
//  NTRefreshView.swift
//  刷新控件
//
//  Created by ntian on 2016/12/22.
//  Copyright © 2016年 ntian. All rights reserved.
//

import UIKit

/// 刷新视图 - 负责刷新相关 UI显示和动画
class NTRefreshView: UIView {
    
    /// 刷新状态
    var refreshState: NTRefreshState = .Normal {
        didSet {
            switch refreshState {
            case .Normal:
                // 恢复状态
                tipIcon.layer.removeAllAnimations()
                UIView.animate(withDuration: 0.25, animations: {
                    self.tipIcon.transform = CGAffineTransform.identity
                })
            case .Pulling:
                tipIcon.layer.removeAllAnimations()
                UIView.animate(withDuration: 0.25, animations: {
                    self.tipIcon.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi + 0.0001))
                })
            case .WillRefresh:
                self.startAnimation(view: tipIcon)
            }
        }
    }
    // 旋转动画
    fileprivate func startAnimation(view: UIView) {
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = (2 * Double.pi + (Double.pi + 0.0001))
        anim.duration = 0.75
        anim.isRemovedOnCompletion = false
        anim.repeatCount = MAXFLOAT
        view.layer.add(anim, forKey: "transform.rotation")
  
    }

    /// 提示图标
    @IBOutlet weak var tipIcon: UIImageView!
    
    class func refreshView() -> NTRefreshView {
        
        let nib = UINib(nibName: "NTRefreshView", bundle: nil)
        return nib.instantiate(withOwner: nil, options: nil)[0] as! NTRefreshView
        
    }
}
