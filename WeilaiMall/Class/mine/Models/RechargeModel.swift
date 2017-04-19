//
//  RechargeModel.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/3/22.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import Foundation
import SwiftyJSON


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
    
    var pay_phone: String
    
    init(value: JSON) {
        user_money = value["user_money"].floatValue
        pay_ratio = value["pay_ratio"].intValue
        pay_pass = value["pay_pass"].intValue
        is_pay = value["is_pay"].boolValue
        pay_phone = value["pay_phone"].stringValue
    }
}



struct VerificationShopRequest: CCRequest {
    
    struct VerificationModel {
        var shop_name: String
    }
    
    let path: String = getshopname
    
    var parameter: [String: Any]
    typealias Response = VerificationModel
    
    func JSONParse(value: JSON) -> [VerificationModel?]? {
        return [VerificationModel(shop_name: value["data"]["shop_name"].stringValue)]
    }

}



struct PaymentRequest: CCRequest {
    
    struct VerificationModel {
        var real_name: String
        
        init(value: JSON) {
            real_name = value["data"]["real_name"].stringValue
        }
    }
    
    let path: String = payment
    
    var parameter: [String: Any]
    typealias Response = VerificationModel
    
    func JSONParse(value: JSON) -> [VerificationModel?]? {
        return [VerificationModel.init(value: value)]
    }
    
}


