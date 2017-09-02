//
//  RNBasicTableViewCell.swift
//  ReadNode
//
//  Created by ntian on 2017/9/2.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit

class RNBasicTableViewCell: UITableViewCell {

    var item: RNSettingsItem? {
        didSet {
            textLabel?.textColor = UIColor.nt_color(hex: 0x35394B)
            textLabel?.font = UIFont.systemFont(ofSize: 13)
            textLabel?.text = item?.title
        }
    }


}
