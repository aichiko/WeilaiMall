//
//  TransferUserModel.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/3/26.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import Foundation
import SwiftyJSON


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
}


