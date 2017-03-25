//
//  ChangePasswordModel.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/3/25.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol CustomCCError: Error {
    var info: String { get }
    var status: Int { get }
}

struct UpdatePassMessage: CustomCCError {
    var status: Int

    var info: String
    
    let access_token: String
    
    
    init(value: JSON) {
        info = value["info"].stringValue
        status = value["status"].intValue
        access_token = value["data"]["access_token"].stringValue
    }
}

struct UpdatePassRequest: CCRequest {
    let path: String = updatepass
    
    var parameter: [String: Any]
    typealias Response = UpdatePassMessage
    
    func JSONParse(value: JSON) -> [UpdatePassMessage?]? {
        return [UpdatePassMessage.init(value: value)]
    }
}


struct UpdatePayPassRequest: CCRequest {
    let path: String = updatepaypass
    
    var parameter: [String: Any]
    typealias Response = String
    
    func JSONParse(value: JSON) -> [String?]? {
        return [""]
    }
}

struct ObtainCodeRequest: CCRequest {
    let path: String = obtaincode
    
    var parameter: [String: Any]
    typealias Response = String
    
    func JSONParse(value: JSON) -> [String?]? {
        return [""]
    }
}

