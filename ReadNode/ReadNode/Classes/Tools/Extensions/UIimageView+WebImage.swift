//
//  UIimageView+WebImage.swift
//  NTWeibo
//
//  Created by ntian on 2017/3/2.
//  Copyright © 2017年 ntian. All rights reserved.
//

import Kingfisher

extension UIImageView {

    /// 隔离 Kingfisher 设置图像函数
    ///
    /// - Parameters:
    ///   - urlString: urlString
    ///   - placeholder: 占位图像
    func nt_setAvatarImage(urlString: String?, placeholder: Image?, isAvator: Bool = false) {
        
        /// 处理 url
        guard let urlString = urlString, let url = URL(string: urlString) else {
            // 设置占位图片
            image = placeholder
            return
        }

        kf.setImage(with: url, placeholder: placeholder, options: []) { [weak self] (image, _, _, _) in
            if isAvator {
                self?.image = image?.nt_acatarImage(size: self?.bounds.size)
            }
        }
    }
    func nt_setImage(urlString: String?, placeholder: Image?, progress:
        DownloadProgressBlock?, completionHandle: CompletionHandler?) {
        
        /// 处理 url
        guard let urlString = urlString, let url = URL(string: urlString) else {
            // 设置占位图片
            image = placeholder
            return
        }
        kf.setImage(with: url, placeholder: placeholder, options: [], progressBlock: progress, completionHandler: completionHandle)
    }
}
