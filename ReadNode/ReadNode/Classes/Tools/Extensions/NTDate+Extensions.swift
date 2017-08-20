//
//  NTDate+Extensions.swift
//  spade
//
//  Created by ntian on 2017/4/8.
//  Copyright © 2017年 ntian. All rights reserved.
//

import Foundation

/// 日期格式化器 不要频繁创建
private let dateFormatter = DateFormatter()
/// 当前日历对象
private let calendar = Calendar.current

extension Date {
    
    
    static func nt_dateString(delta: TimeInterval) -> String {
        let date = Date(timeIntervalSinceNow: delta)
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: date)
    }

    /**
     刚刚(1分钟内)
     X分钟前(1小时内)
     X小时前(当天)
     昨天 HH:mm (昨天)
     MM-dd HH:mm(1年内)
     yyyy-MM-dd HH:mm(更早)
     */
    var nt_dateDescription: String {
        var fmt = "MM-dd"
        if calendar.isDateInToday(self) || calendar.isDateInYesterday(self) {
            let delta = -Int(self.timeIntervalSinceNow)
            if delta < 60 {
                return "\(delta)s"
            }
            if delta < 3600 {
                return "\(delta / 60)m"
            }
            if delta < 86400 {
                return "\(delta / 3600)h"
            }
        } else {
            let year = calendar.component(.year, from: self)
            let thisYear = calendar.component(.year, from: Date())
            if year != thisYear {
                fmt = "yyyy-" + fmt
            }
        }
        dateFormatter.dateFormat = fmt
        return dateFormatter.string(from: self)
    }
}
