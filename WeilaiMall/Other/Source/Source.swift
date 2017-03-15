//
//  Source.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/2/28.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

// 常用字体颜色
let CCGrayTextColor = UIColor.colorWithString("#999999")
let CCTitleTextColor = UIColor.colorWithString("#333333")
// 购买按钮背景颜色 以及 价格数字的颜色
let CCOrangeColor = UIColor.colorWithString("#FF6B26")
// button 不可用 时的背景颜色
let CCButtonGrayColor = UIColor(red:0.80, green:0.81, blue:0.81, alpha:1.00)

// 常用字体
let CCTextFont = UIFont.CCsetfont(14)

typealias CCButtonAction = (_ button: UIButton) -> Void

extension UIFont {
    
    class func CCsetfont(_ size: CGFloat) -> UIFont? {
        let realSize = (UIScreen.main.bounds.width>375) ? (size*414.0/375.0): size
        
        //let family = "PingFang-SC-Regular"
        //let font = UIFont.init(name: family, size: realSize)
        let font = UIFont.systemFont(ofSize: realSize)
        return font
    }
    
    class func CCsetfont(_ size: CGFloat, _ fontFamily: String?) -> UIFont? {
        let realSize = (UIScreen.main.bounds.width>375) ? (size*414.0/375.0): size
        
        let family = fontFamily ?? "PingFang-SC-Regular"
        let font = UIFont.init(name: family, size: realSize)
        return font!
    }
}

extension UIColor {
    class func colorWithString(_ color: (rgb: String, alpha: Float)) -> UIColor {
        var cString = color.rgb.trimmingCharacters(in:CharacterSet.whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            let index = cString.index(cString.startIndex, offsetBy:1)
            cString = cString.substring(from: index)
        }
        
        if (cString.characters.count != 6) {
            return UIColor.red
        }
        
        let rIndex = cString.index(cString.startIndex, offsetBy: 2)
        let rString = cString.substring(to: rIndex)
        let otherString = cString.substring(from: rIndex)
        let gIndex = otherString.index(otherString.startIndex, offsetBy: 2)
        let gString = otherString.substring(to: gIndex)
        let bIndex = cString.index(cString.endIndex, offsetBy: -2)
        let bString = cString.substring(from: bIndex)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(color.alpha))
    }
    
    class func colorWithString(_ rgb: String) -> UIColor{
        return UIColor.colorWithString((rgb, 1.0))
    }
}

/// tableView 的协议（每次都写一遍真是太麻烦了）
protocol CCTableViewProtocol {
    var tableView: UITableView { get set }
    
    func configTableView() -> Void
}
