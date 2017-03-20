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
import SwiftyJSON
import MBProgressHUD

// 常用字体颜色
let CCGrayTextColor = UIColor.colorWithString("#999999")
let CCTitleTextColor = UIColor.colorWithString("#333333")
// 购买按钮背景颜色 以及 价格数字的颜色
let CCOrangeColor = UIColor.colorWithString("#FF6B26")
// button 不可用 时的背景颜色
let CCButtonGrayColor = UIColor(red:0.80, green:0.81, blue:0.81, alpha:1.00)

// 常用字体
let CCTextFont = UIFont.CCsetfont(14)

let access_token = "4297f44b13955235245b2497399d7a93"

/// 用户是否登录
let isLogin = UserDefaults.init().value(forKey: "isLogin") as? Bool ?? false

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

// MARK: - MBProgressHUD 的扩展方法
extension MBProgressHUD {
    
    class func  showErrorAdded(message: String, to view: UIView?) {
        self.showErrorAdded(message: message, image: nil, to: view)
    }
    
    class func  showErrorAdded(message: String ,image imageName: String?, to view: UIView?) {
        var hudView = view
        if hudView == nil {
            hudView = UIApplication.shared.keyWindow
        }
        let hud = MBProgressHUD.showAdded(to: hudView!, animated: true)
        hud.mode = .customView
        if imageName != nil {
            let imageView = UIImageView.init(image: UIImage.init(named: imageName!))
            hud.customView = imageView
        }
        hud.label.text = message
        hud.hide(animated: true, afterDelay: 2)
        hud.removeFromSuperViewOnHide = true
        if message.characters.count > 10 {
            hud.label.text = ""
            hud.detailsLabel.text = message
            hud.detailsLabel.font = UIFont.init(name: "PingFang-SC-Regular", size: 16)!
        }
    }
}


/// tableView 的协议（每次都写一遍真是太麻烦了）
protocol CCTableViewProtocol {
    var tableView: UITableView { get set }
    
    func configTableView() -> Void
}

extension String {
    
    func MD5() -> String {
        
        let str = self.cString(using: .utf8)
        let strLen = CC_LONG(self.lengthOfBytes(using: .utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.deinitialize()
        return String(format: hash as String)
 
    }
    
    static func MD5(with parameter: [String: Any]) -> String {
        
        let dic = parameter
        var array: [String] = []
        if dic.first?.key == "type" {
            
        }
        for item in dic {
            array.append("\(item.key)=\(item.value)")
        }
        array.sort()
        var resultStr: String = array.joined(separator: "&")
        resultStr.append("&key=weilai8088")
        
        return resultStr.MD5()
    }
}



