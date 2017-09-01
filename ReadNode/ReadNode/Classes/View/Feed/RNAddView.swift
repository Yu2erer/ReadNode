//
//  RNAddView.swift
//  ReadNode
//
//  Created by ntian on 2017/8/13.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit

@objc protocol RNAddViewDelegate: NSObjectProtocol {
    /// 按下关闭按钮
    @objc optional func didClickClose()
    /// 按下保存按钮
    ///
    /// - Parameter urlString: textView 里的 urlString
    @objc optional func didClickSave(urlString: String)
}
class RNAddView: UIView {

    /// 占位标签
    @IBOutlet weak var placeHolder: UILabel!
    /// 文本输入框
    @IBOutlet weak var textView: UITextView!
    weak var viewDelegate: RNAddViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.delegate = self
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if newSuperview != nil {
            self.textView.becomeFirstResponder()
        }
    }
    
    @IBAction fileprivate func addHttp(_ sender: UIButton) {
        self.placeHolder.alpha = 0
        textView.text.append("http://")
    }
    
    @IBAction fileprivate func addHttps(_ sender: UIButton) {
        self.placeHolder.alpha = 0
        textView.text.append("https://")
    }
    
    @IBAction fileprivate func addXml(_ sender: UIButton) {
        self.placeHolder.alpha = 0
        textView.text.append(".xml")
    }
    
    // 使用代理 交给外界处理
    @IBAction fileprivate func close(_ sender: UIButton) {
        textView.resignFirstResponder()
        textView.text = nil
        viewDelegate?.didClickClose?()
        self.placeHolder.alpha = 1
    }
    @IBAction fileprivate func save(_ sender: UIButton) {
        textView.resignFirstResponder()
        viewDelegate?.didClickSave?(urlString: textView.text)
        textView.text = nil
        self.placeHolder.alpha = 1
    }
}
// MARK: - UITextViewDelegate
extension RNAddView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if (NSString(string: textView.text).length == 0) {
            self.placeHolder.alpha = 1
        } else {
            self.placeHolder.alpha = 0
        }
    }
    // 将键盘的 Done 改成结束编辑
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
