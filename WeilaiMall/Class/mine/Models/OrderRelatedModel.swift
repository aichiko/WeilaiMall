//
//  OrderRelatedModel.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/3/21.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import Foundation
import SwiftyJSON

struct OrderListRequest: CCRequest {
    let path: String = orderlist
    
    var parameter: [String: Any]
    typealias Response = OrderListModel
    
    func JSONParse(value: JSON) -> [OrderListModel?]? {
        var models: [OrderListModel] = []
        for json in value["data"].arrayValue {
            models.append(OrderListModel.init(value: json))
        }
        return models
    }
}

struct OrderDetailRequest: CCRequest {
    let path: String = orderinfo
    
    var parameter: [String: Any]
    typealias Response = OrderListModel
    
    func JSONParse(value: JSON) -> [OrderListModel?]? {
        var models: [OrderListModel] = []
        for json in value["data"].arrayValue {
            models.append(OrderListModel.init(value: json))
        }
        return models
    }
}

struct OrderListModel {
    
    var order_id: Int
    var goods_price: Float
    /// 0：待发货  1:待收货 2:已收货
    var state: Int
    var order_goods: [OrderGoodsModel]
    var goods_num: Int
    
    /// 店铺ID
    var shop_id: Int
    var shop_name: String
    
    init(value: JSON) {
        order_id = value["order_id"].intValue
        state = value["state"].intValue
        goods_price = value["goods_price"].floatValue
        goods_num = value["goods_num"].intValue
        shop_id = value["shop_id"].intValue
        shop_name = value["shop_name"].stringValue
        
        order_goods = OrderGoodsModel.goods(with: value["order_goods"])
    }
}

struct OrderDetailModel {
    var shop_id: Int
    var shop_name: String
    var order_id: Int
    /// 订单编号
    var order_sn: Int
    var goods_num: Int
    var goods_price: Float
    /// 0：待发货  1:待收货 2:已收货
    var state: Int
    
    /// 订单时间
    var add_time: String
    
    var mobile_phone: String
    /// 收货地址
    var address: String
    
    /// 快递名称
    var shipping_name: String
    /// 快递单号
    var invoice_no: Int
    
    var user_name: String
    var order_goods: [OrderGoodsModel]
}

struct OrderGoodsModel {
    
    
    static func goods(with goods : JSON) -> [OrderGoodsModel] {
        var models: [OrderGoodsModel] = []
        for value in goods.arrayValue {
            models.append(OrderGoodsModel.init(goods: value))
        }
        return models
    }
    
    init(goods: JSON) {
        goods_id = goods["goods_id"].intValue
        goods_name = goods["goods_name"].stringValue
        
        goods_price = goods["goods_price"].floatValue
        goods_img = goods["goods_img"].stringValue
        goods_num = goods["goods_num"].intValue
    }
    
    var goods_id: Int
    var goods_name: String
    
    var goods_price: Float
    var goods_img: String
    var goods_num: Int
}
