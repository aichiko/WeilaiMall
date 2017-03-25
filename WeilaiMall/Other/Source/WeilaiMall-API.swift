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
/// 修改登录密码
let updatepass = "Rest/auth/updatepass"
/// 修改支付密码
let updatepaypass = "Rest/auth/updatepaypass"

/// 操作记录
let accountlog = "Rest/user/accountlog"
/// 订单列表
let orderlist = "Rest/order/orderlist"
/// 订单详情
let orderinfo = "Rest/order/orderinfo"
/// 用户余额
let getusermoney = "Rest/user/getusermoney"
