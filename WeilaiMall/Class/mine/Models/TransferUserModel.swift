//
//  TransferUserModel.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/3/26.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import Foundation
import SwiftyJSON

/// status  1007: 不能给自己转账   1008: 账号不存在  1009: 账号已冻结
/// 验证转账用户 相关错误
enum VerificateError: Int, Error {
    case busyError = -1
    case otherError = -1000
    
    case handleFailed = 1000
    case invalidToken = 1001
    case invalidSign = 1002
    case lackParameter = 1003
    case noAccess = 1004
    case passWordError = 1005
    case accountFreeze = 1006
    
    case cannotSelf = 1007
    case noAccount = 1008
    case userFreeze = 1009
    
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
        case .cannotSelf:
            return "不能给自己转账"
        case .noAccount:
            return "账号不存在"
        case .userFreeze:
            return "账号已冻结"
        default:
            return "网络错误"
        }
    }
}

struct VerificationRequest: CCRequest {
    
    struct VerificationModel {
        var real_name: String
        
        init(value: JSON) {
            real_name = value["data"]["real_name"].stringValue
        }
    }
    
    let path: String = getrealname
    
    var parameter: [String: Any]
    typealias Response = VerificationModel
    
    func JSONParse(value: JSON) -> [VerificationModel?]? {
        return [VerificationModel.init(value: value)]
    }
    
    func parse(status: Int) -> Error? {
        return VerificateError.init(rawValue: status)
    }
}

/// status 1007: 支付密码为空，请先设置支付密码  1008: 余额不足   1009: 支付密码不正确
/// 验证转账用户 相关错误
enum TransferError: Int, Error {
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
    case nomoney = 1008
    case passError = 1009
    
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
            return "请先设置支付密码"
        case .nomoney:
            return "余额不足"
        case .passError:
            return "支付密码不正确"
        default:
            return "网络错误"
        }
    }
}

struct TransferRequest: CCRequest {
    
    struct VerificationModel {
        var real_name: String
        
        init(value: JSON) {
            real_name = value["data"]["real_name"].stringValue
        }
    }
    
    let path: String = accounts
    
    var parameter: [String: Any]
    typealias Response = VerificationModel
    
    func JSONParse(value: JSON) -> [VerificationModel?]? {
        return [VerificationModel.init(value: value)]
    }
    
    func parse(status: Int) -> Error? {
        return TransferError.init(rawValue: status)
    }
}


