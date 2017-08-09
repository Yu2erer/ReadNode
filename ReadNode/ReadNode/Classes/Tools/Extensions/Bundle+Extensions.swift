//
//  Bundle+Extensions.swift
//
//  Created by apple on 16/6/29.
//  Copyright © 2016年 itcast. All rights reserved.
//

import Foundation

extension Bundle {

    // 计算型属性类似于函数，没有参数，有返回值
    class var namespace: String {
        return main.infoDictionary?["CFBundleName"] as? String ?? ""
    }
    /// 返回当前版本
    class var currentVerison: String {
        return main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
    
    
}
