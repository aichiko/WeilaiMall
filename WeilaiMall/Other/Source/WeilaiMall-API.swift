//
//  WeilaiMall-API.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/3/24.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import Foundation

let requestHost = testHost

let testHost = "http://114.215.19.98/api/web/"

// API 列表

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
