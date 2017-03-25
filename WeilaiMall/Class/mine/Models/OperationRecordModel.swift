//
//  OperationRecordModel.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/3/21.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import Foundation
import SwiftyJSON

struct OperationRecordRequest: CCRequest {
    
    let path: String = accountlog
    
    var parameter: [String: Any]
    typealias Response = OperationRecordModel
    
    func JSONParse(value: JSON) -> [OperationRecordModel?]? {
        var models: [OperationRecordModel] = []
        for json in value["data"].arrayValue {
            models.append(OperationRecordModel.init(value: json))
        }
        return models
    }
}


struct OperationRecordModel {
    var log_id: Int
    var user_id: Int
    /// 余额
    var user_money: Float
    /// 待返积分
    var rebate: Float
    /// 推广赠送
    var payin: Float
    /// 推广额度
    var highreward: Float
    /// 累计消费
    var pay_points: Float
    /// 账户变动时间
    var change_time: Date
    /// 账户变动原因
    var change_desc: String
    
    init(value: JSON) {
        log_id = value["log_id"].intValue
        user_id = value["user_id"].intValue
        user_money = value["user_money"].floatValue
        rebate = value["rebate"].floatValue
        payin = value["payin"].floatValue
        highreward = value["highreward"].floatValue
        pay_points = value["pay_points"].floatValue
        
        //let formatter = DateFormatter.init()
        var date = Date.init(timeIntervalSince1970: TimeInterval.init(value["change_time"].intValue))
        let interval = TimeZone.current.secondsFromGMT()
        date.addTimeInterval(TimeInterval(interval))
        change_time = date
        
        change_desc = value["change_desc"].stringValue
    }
}
