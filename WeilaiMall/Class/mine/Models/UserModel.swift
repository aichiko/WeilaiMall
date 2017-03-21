//
//  UserModel.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/3/19.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import Foundation
import SwiftyJSON

struct LoginRequest: CCRequest {
    //internal var Error: RequestError

    //typealias Error = RequestError
    let path: String = "Rest/auth/login"
    
    var parameter: [String: Any]
    typealias Response = String
    
    func JSONParse(value: JSON) -> [Response?]? {
        return nil
    }
}

struct UserInfoRequest: CCRequest {
    typealias Error = RequestError
    let path: String = "Rest/user/getinfo"
    
    var parameter: [String: Any]
    typealias Response = UserModel
    
    func JSONParse(value: JSON) -> [UserModel?]? {
        
        return [UserModel.init(value: value)]
    }
}


/*
 [
 user_id         用户ID
 user_name       用户名
 real_name       真实姓名
 mobile_phone    手机号码
 email           电子邮箱
 sex             性别
 birthday        生日
 user_money      余额
 rebate          待返积分
 payin           推广赠送
 highreward      推广额度
 pay_points      累计消费
 ]
 */
struct UserModel {
    var user_id: Int
    var user_name: String
    var real_name: String
    var mobile_phone: Int
    var email: String
    var sex: Int
    var birthday: String
    var user_money: Float
    var rebate: Float
    var payin: Float
    var highreward: Float
    var pay_points: Float
    
    init?(user: User) {
        user_id = Int(user.user_id)
        user_name = user.user_name!
        real_name = user.real_name!
        mobile_phone = Int(user.mobile_phone)
        sex = Int(user.sex)
        email = user.email!
        birthday = user.birthday!
        user_money = user.user_money
        rebate = user.rebate
        payin = user.payin
        highreward = user.highreward
        pay_points = user.pay_points
    }
    
    init(value: JSON) {
        let data = value["data"]
        user_id = data["user_id"].intValue
        user_name = data["user_name"].stringValue
        real_name = data["real_name"].stringValue
        mobile_phone = data["mobile_phone"].intValue
        sex = data["sex"].intValue
        email = data["email"].stringValue
        birthday = data["birthday"].stringValue
        user_money = data["user_money"].floatValue
        rebate = data["rebate"].floatValue
        payin = data["payin"].floatValue
        highreward = data["highreward"].floatValue
        pay_points = data["pay_points"].floatValue
    }
}
