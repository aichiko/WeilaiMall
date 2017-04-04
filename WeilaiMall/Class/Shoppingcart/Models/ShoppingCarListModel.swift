//
//  ShoppingCarListModel.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/3/28.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ShoppingCartListRequest: CCRequest {
    let path: String = cartlist
    
    var parameter: [String: Any]
    typealias Response = ShoppingCartListModel
    
    func JSONParse(value: JSON) -> [ShoppingCartListModel?]? {
        var models: [ShoppingCartListModel] = []
        for item in value["data"].arrayValue {
            let model = ShoppingCartListModel.init(value: item)
            models.append(model)
        }
        return models
    }
}


struct CartChangenumRequest: CCRequest {
    let path: String = changenum
    
    var parameter: [String: Any]
    typealias Response = ShoppingCartListModel
    
    func JSONParse(value: JSON) -> [ShoppingCartListModel?]? {
        var models: [ShoppingCartListModel] = []
        for item in value["data"].arrayValue {
            let model = ShoppingCartListModel.init(value: item)
            models.append(model)
        }
        return models
    }
}

struct CartDeleteRequest: CCRequest {
    let path: String = cartdel
    
    var parameter: [String: Any]
    typealias Response = ShoppingCartListModel
    
    func JSONParse(value: JSON) -> [ShoppingCartListModel?]? {
        var models: [ShoppingCartListModel] = []
        for item in value["data"].arrayValue {
            let model = ShoppingCartListModel.init(value: item)
            models.append(model)
        }
        return models
    }
}

struct ShoppingCartGoods: Equatable {
    
    /// 购物车记录id
    var rec_id: Int
    var goods_id: Int
    var goods_name: String
    var goods_num: Int
    var goods_price: Float
    var goods_img: String
    
    public static func ==(lhs: ShoppingCartGoods, rhs: ShoppingCartGoods) -> Bool {
        return lhs.rec_id==rhs.rec_id
    }
    
    init(value: JSON) {
        rec_id = value["rec_id"].intValue
        goods_id = value["goods_id"].intValue
        goods_name = value["goods_name"].stringValue
        goods_num = value["goods_num"].intValue
        goods_price = value["goods_price"].floatValue
        goods_img = value["goods_img"].stringValue
    }
    
    static func goods(with value: JSON) -> [ShoppingCartGoods] {
        var models: [ShoppingCartGoods] = []
        for item in value.arrayValue {
            let model = ShoppingCartGoods(value: item)
            models.append(model)
        }
        return models
    }
}

struct ShoppingCartListModel {
    var shop_id: Int
    var shop_name: String
    
    var cart_goods: [ShoppingCartGoods]
    
    init(value: JSON) {
        shop_id = value["shop_id"].intValue
        shop_name = value["shop_name"].stringValue
        cart_goods = ShoppingCartGoods.goods(with: value["cart_goods"])
    }
    
}
