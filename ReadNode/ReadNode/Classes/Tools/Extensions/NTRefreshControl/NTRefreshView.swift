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
                tipIcon.isHidden = false
                indicator.stopAnimating()
                
                UIView.animate(withDuration: 0.25, animations: {
                    self.tipIcon.transform = CGAffineTransform.identity
                })
            case .Pulling:
                UIView.animate(withDuration: 0.25, animations: {
                    self.tipIcon.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi + 0.0001))
                })
            case .WillRefresh:
                tipIcon.isHidden = true
                indicator.startAnimating()
            }
        }
    }

    /// 提示图标
    @IBOutlet weak var tipIcon: UIImageView!
    /// 指示器
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    class func refreshView() -> NTRefreshView {
        
        let nib = UINib(nibName: "NTRefreshView", bundle: nil)
        return nib.instantiate(withOwner: nil, options: nil)[0] as! NTRefreshView
        
    }
}
