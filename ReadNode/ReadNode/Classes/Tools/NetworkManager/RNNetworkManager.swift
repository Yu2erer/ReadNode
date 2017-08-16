//
//  RNNetworkManager.swift
//  ReadNode
//
//  Created by ntian on 2017/8/11.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit
import Alamofire

class RNNetworkManager {
    
    private init() {}
    // 创建单例
    static let shared = RNNetworkManager()
    
    func request(urlString: String, completion: @escaping (_ isSuccess: Bool) -> ()) {
        guard let url = URL(string: urlString) else {
            return
        }
        Alamofire.request(url).responseRSS { (response) in
            if response.result.isFailure {
                completion(false)
                return
            }
            let feed = response.result.value
            if feed?.items.count == 0 {
                completion(false)
                return
            }
            print(feed?.title)
            completion(true)
            
        }
    }
}
