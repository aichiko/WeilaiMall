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
    var user_money: String
    /// 待返积分
    var rebate: String
    /// 推广赠送
    var payin: String
    /// 推广额度
    var highreward: String
    /// 累计消费
    var pay_points: String
    /// 账户变动时间
    var change_time: String
    /// 账户变动原因
    var change_desc: String
    
    init(value: JSON) {
        log_id = value["log_id"].intValue
        user_id = value["user_id"].intValue
        user_money = value["user_money"].stringValue
        rebate = value["rebate"].stringValue
        payin = value["payin"].stringValue
        highreward = value["highreward"].stringValue
        pay_points = value["pay_points"].stringValue
        
        //let formatter = DateFormatter.init()
//        var date = Date.init(timeIntervalSince1970: TimeInterval.init(value["change_time"].intValue))
//        let interval = TimeZone.current.secondsFromGMT()
//        date.addTimeInterval(TimeInterval(interval))
        change_time = value["change_time"].stringValue
        
        change_desc = value["change_desc"].stringValue
    }
}
