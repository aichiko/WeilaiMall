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

var access_token: String = {
    return UserDefaults.init().value(forKey: "access_token") as! String
    
}()

let firstLaunch = UserDefaults.init().value(forKey: "firstLaunch") as? Bool ?? false

/// 用户是否登录
var isLogin: Bool = {
    return UserDefaults.init().value(forKey: "isLogin") as? Bool ?? false
}()

let RefreshInfo = NSNotification.Name(rawValue: "refreshUserInfo")

let ReloadHeadView = NSNotification.Name(rawValue: "reloadHeadView")

let ALIPayResult = NSNotification.Name(rawValue: "ALIPayResult")

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
    
    class func showMessage(message: String?, view: UIView?) -> MBProgressHUD {
        var hudView = view
        if hudView == nil {
            hudView = UIApplication.shared.keyWindow
        }
        let hud = MBProgressHUD.showAdded(to: hudView!, animated: true)
        hud.label.text = message
        hud.removeFromSuperViewOnHide = true
        if (message?.characters.count)! > 10 {
            hud.label.text = ""
            hud.detailsLabel.text = message
            hud.detailsLabel.font = UIFont.init(name: "PingFang-SC-Regular", size: 16)!
        }
        return hud
    }
    
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
        
        guard parameter.count > 0 else {
            return "key=weilai8088".MD5()
        }
        
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

extension String {
    
    func checkPhoneNumber() -> Bool {
        /**
         * 移动号段正则表达式
         */
        let CM_NUM = "^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        let CU_NUM = "^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        let CT_NUM = "^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        
        let pred1 =  NSPredicate.init(format: "SELF MATCHES %@", CM_NUM)
        let isMatch1 = pred1.evaluate(with: self)
        
        let pred2 =  NSPredicate.init(format: "SELF MATCHES %@", CU_NUM)
        let isMatch2 = pred2.evaluate(with: self)
        
        let pred3 =  NSPredicate.init(format: "SELF MATCHES %@", CT_NUM)
        let isMatch3 = pred3.evaluate(with: self)
        
        if isMatch1 || isMatch2 || isMatch3 {
            return true;
        }else{
            return false;
        }
    }
    
    func isValidateEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        let emailTest = NSPredicate.init(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: self)
    }
}


