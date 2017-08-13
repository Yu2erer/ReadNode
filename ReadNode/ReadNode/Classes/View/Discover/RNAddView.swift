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
    @objc optional func didClickSave()
}
class RNAddView: UIView {

    @IBOutlet weak var textView: UITextView!
    weak var viewDelegate: RNAddViewDelegate?
    
    @IBAction func addHttp(_ sender: UIButton) {
    }
    
    @IBAction func addHttps(_ sender: UIButton) {
    }
    
    @IBAction func addXml(_ sender: UIButton) {
    }
    
    
    @IBAction func close(_ sender: UIButton) {
        viewDelegate?.didClickClose?()
    }
    @IBAction func save(_ sender: UIButton) {
        viewDelegate?.didClickSave?()
    }
}
