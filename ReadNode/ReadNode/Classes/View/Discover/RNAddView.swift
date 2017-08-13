//
//  RNAddView.swift
//  ReadNode
//
//  Created by ntian on 2017/8/13.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit

@objc protocol RNAddViewDelegate: NSObjectProtocol {
    @objc optional func didClickClose()
}
class RNAddView: UIView {

    weak var viewDelegate: RNAddViewDelegate?
    @IBAction func close(_ sender: UIButton) {
        viewDelegate?.didClickClose?()
    }
}
