//
//  RechargeModel.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/3/22.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import Foundation
import SwiftyJSON


/// status 1007: 支付密码为空，请先设置支付密码  1008: 余额不足   1009: 支付密码不正确
/// 转账 相关错误
enum RechangeError: Int, Error {
    case busyError = -1
    case otherError = -1000
    
    case handleFailed = 1000
    case invalidToken = 1001
    case invalidSign = 1002
    case lackParameter = 1003
    case noAccess = 1004
    case passWordError = 1005
    case accountFreeze = 1006
    
    case noPassword = 1007
    case noBalance = 1008
    case passWordWrong = 1009
    
    func info() -> String {
        switch self {
        case .busyError:
            return "系统繁忙，稍后再试"
        case .handleFailed:
            return "处理失败"
        case .invalidToken:
            return "access_token非法"
        case .invalidSign:
            return "sign验证失败"
        case .lackParameter:
            return "请求参数缺失"
        case .noAccess:
            return "无操作权限"
        case .passWordError:
            return "账号或密码不正确"
        case .accountFreeze:
            return "账号被冻结"
        case .noPassword:
            return "支付密码为空"
        case .noBalance:
            return "余额不足"
        case .passWordWrong:
            return "支付密码不正确"
        default:
            return "网络错误"
        }
    }
}



struct UserBalanceRequest: CCRequest {
    let path: String = getusermoney
    
    var parameter: [String: Any]
    typealias Response = AccountBalance
    
    func JSONParse(value: JSON) -> [AccountBalance?]? {
        return [AccountBalance.init(value: value["data"])]
    }
}

struct AccountBalance {
    /// 余额
    var user_money: Float
    /// 系统倍数
    var pay_ratio: Int
    /// 0;支付密码为空，跳转到密码设置页面 1;正常支付
    var pay_pass: Int
    /// 0:未开通B类支付  1：开通B类支付（显示收款            二维码）
    var is_pay: Bool
    
    init(value: JSON) {
        user_money = value["user_money"].floatValue
        pay_ratio = value["pay_ratio"].intValue
        pay_pass = value["pay_pass"].intValue
        is_pay = value["is_pay"].boolValue
    }
}
