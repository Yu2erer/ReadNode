//
//  ReadNode.swift
//  ReadNode
//
//  Created by ntian on 2017/8/21.
//  Copyright © 2017年 ntian. All rights reserved.
//

import Foundation

/// 添加了新的Feed通知
let RNAddFeedNotification = "RNAddFeedNotification"
let isHaveSetting = UserDefaults.standard.string(forKey: "isHaveSetting")
var fontSize = UserDefaults.standard.integer(forKey: "fontSize")
// Path
let rnDBPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/ReadNode.db"
let likeDBpath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/LikeReadNode.db"


