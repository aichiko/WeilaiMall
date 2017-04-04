//
//  ShoppingCarClearModel.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/4/1.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import Foundation
import SwiftyJSON

/// 结算 请求
struct CarGoListRequest: CCRequest {
    let path: String = cargolist
    
    var parameter: [String: Any]
    typealias Response = ShoppingClearModel
    
    func JSONParse(value: JSON) -> [ShoppingClearModel?]? {
        return [ShoppingClearModel.init(value: value["data"])]
    }
}

/// 结算 请求
struct CarSuborderRequest: CCRequest {
    let path: String = suborder
    
    var parameter: [String: Any]
    typealias Response = ShoppingClearModel
    
    func JSONParse(value: JSON) -> [ShoppingClearModel?]? {
        return [ShoppingClearModel.init(value: value["data"])]
    }
}

struct ShoppingCartAdress {
    var address_id: Int
    var address: String
    var mobile: Int64
    var consignee: String
    
    init?(value: JSON) {
        guard value["address_id"].intValue != 0 else {
            return nil
        }
        address_id = value["address_id"].intValue
        address = value["address"].stringValue
        mobile = value["mobile"].int64Value
        consignee = value["consignee"].stringValue
    }
}

struct ShoppingClearModel {
    
    struct ShoppingCart {
        var shop_id: Int
        var shop_name: String
        var cart_goods: [ShoppingCartGoods]
        var shop_num: Int
        var shop_price: Float
        
        init(value: JSON) {
            shop_id = value["shop_id"].intValue
            shop_name = value["shop_name"].stringValue
            shop_num = value["shop_num"].intValue
            shop_price = value["shop_price"].floatValue
            cart_goods = ShoppingCartGoods.goods(with: value["cart_goods"])
        }
        
        static func carts(with value: JSON) -> [ShoppingCart] {
            var models: [ShoppingCart] = []
            for item in value.arrayValue {
                let model = ShoppingCart.init(value: item)
                models.append(model)
            }
            return models
        }
    }
    
    var carts: [ShoppingCart]
    var total_num: Int
    var total_price: Float
    
    var address: ShoppingCartAdress?
    
    
    init(value: JSON) {
        carts = ShoppingCart.carts(with: value["cart"])
        total_num = value["total_num"].intValue
        total_price = value["total_price"].floatValue
        address = ShoppingCartAdress.init(value: value["address"])
    }
}

