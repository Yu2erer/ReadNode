//
//  RNNetworkManager.swift
//  ReadNode
//
//  Created by ntian on 2017/8/11.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit
import FeedKit

class RNNetworkManager {
    
    private init() {}
    // 创建单例
    static let shared = RNNetworkManager()
    
    func request(urlString: String, completion: @escaping (_ isSuccess: Bool) -> ()) {
        guard let url = URL(string: urlString) else {
            return
        }
        FeedParser(URL: url)?.parseAsync(result: { (result) in
            
        })
    }
}
