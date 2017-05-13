//
//  WeilaiMall-API.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/3/24.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import Foundation

let webViewHost = webViewHost_production

let webViewHost_test = "http://139.196.124.0/#/"

let webViewHost_production = "https://www.weccmall.com/h5/#/"

let requestHost = productionHost

let testHost = "http://114.215.19.98/api/web/"

let productionHost = "https://www.weccmall.com/api/web/"

// API 列表

/// 版本更新
let checkversion = "Rest/user/checkversion"

/// 获取验证码
let obtaincode = "Rest/auth/obtaincode"

/// 登录
let login = "Rest/auth/login"
/// 个人信息
let getinfo = "Rest/user/getinfo"
/// 修改用户信息
let updateuser = "Rest/user/updateuser"

/// 修改登录密码
let updatepass = "Rest/auth/updatepass"
/// 修改支付密码
let updatepaypass = "Rest/auth/updatepaypass"
/// 找回密码
let findpass = "Rest/auth/findpass"

/// 检查用户获取用户姓名
let getrealname = "Rest/user/getrealname"
/// 转账
let accounts = "Rest/user/accounts"

/// 获取店铺名称
let getshopname = "Rest/user/getshopname"

/// 支付结算
let payment = "Rest/user/payment"

/// 操作记录
let accountlog = "Rest/user/accountlog"
/// 订单列表
let orderlist = "Rest/order/orderlist"
/// 订单详情
let orderinfo = "Rest/order/orderinfo"
/// 确认收货
let affirmorder = "Rest/order/affirmorder"
/// 用户余额
let getusermoney = "Rest/user/getusermoney"

/// 热搜词语
let hotsearch = "Rest/public/hotsearch"

/// 添加购物车
let addcart = "Rest/order/addcart"
/// 购物车数量
let getcartnum = "Rest/order/getcartnum"
/// 购物车
let cartlist = "Rest/order/cartlist"
/// 购物车更改数量
let changenum = "Rest/order/changenum"
/// 删除订单
let cartdel = "Rest/order/cartdel"
/// 结算清单
let cargolist = "Rest/order/cargolist"
/// 提交订单
let suborder = "Rest/order/suborder"
/// aes解密
let aesdecrypt = "Rest/user/aesdecrypt"
/// 生成支付宝充值订单
let recharge = "Rest/pay/recharge"
/// 判断充值成功与否
let checkpay = "Rest/pay/checkpay"
