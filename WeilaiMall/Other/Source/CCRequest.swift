//
//  CCRequest.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/2/28.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire


/*
 -1    	 系统繁忙，稍后再试
 0     	 处理成功
 1000    处理失败
 1001    access_token非法
 1002    sign验证失败
 1003    请求参数缺失
 1004    无操作权限
 1005    账号或密码不正确
 1006    账号被冻结
 */
enum RequestError: Int, Error {
    case busyError = -1
    case handleFailed = 1000
    case invalidToken = 1001
    case invalidSign = 1002
    case lackParameter = 1003
    case noAccess = 1004
    case passWordError = 1005
    case accountFreeze = 1006
    case otherError
    
    func info() -> String {
        switch self {
        case .busyError:
            return "系统繁忙，稍后再试"
        case .handleFailed:
            return "处理失败"
        case .invalidToken:
            return "access_token非法"
        case .invalidSign:
            return "sign验证失败"
        case .lackParameter:
                return "请求参数缺失"
        case .noAccess:
            return "无操作权限"
        case .passWordError:
            return "账号或密码不正确"
        case .accountFreeze:
            return "账号被冻结"
        default:
            return "网络错误"
        }
    }
}


//也可以为 URLSessionClient 添加一个单例来减少请求时的创建开销
struct URLSessionClient: Client {

    let host = "http://114.215.19.98/api/web/"
    /*
    internal func send<T : CCRequest>(_ r: T, handler: @escaping ([T.Response?], Error?) -> Void) {
        let url = URL(string: host.appending(r.path))!
        var request = URLRequest(url: url)
        request.httpMethod = r.method.rawValue
        let bodyStr: String = getHttpBodyString(r.parameter)
        request.httpBody = bodyStr.data(using: .utf8)
        request.timeoutInterval = 10.0
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let data = data, let res: [T.Response?] = r.parse(data: data) {
                DispatchQueue.main.async { handler(res, error) }
            } else {
                NSLog("error === \(error)")
                DispatchQueue.main.async { handler([], error) }
            }
        }
        task.resume()
    }
    */
    
     internal func alamofireSend<T : CCRequest>(_ r: T, handler: @escaping ([T.Response?], RequestError?) -> Void) {
        let sign = String.MD5(with: r.parameter)
        var newDic = r.parameter
        newDic.updateValue(sign, forKey: "sign")
        let url = host.appending(r.path)
        Alamofire.request(url, method: .post, parameters: newDic).responseJSON { (response) in
            debugPrint("data === \(response.data)")
            if response.result.isSuccess {
                let value = JSON(response.result.value!)
                debugPrint("value ==== \(value)")
                if value["status"].intValue == 0 {
                    print("请求成功")
                    if let models = r.JSONParse(value: value) {
                        DispatchQueue.main.async { handler(models, nil) }
                    }
                }else {
                    DispatchQueue.main.async { handler([], RequestError.init(rawValue: value["status"].intValue)) }
                }
            }else {
                NSLog("error === \(response.result.error)")
                DispatchQueue.main.async { handler([], RequestError(rawValue: 1007)) }
            }
        }
     }
}

protocol Decodable {
    /// 返回一个model
    //func parse(data: Data) -> Self?
}

protocol Client {
    var host: String { get }
    func alamofireSend<T: CCRequest>(_ r: T, handler: @escaping([T.Response?], RequestError?) -> Void)
}

protocol CCRequest {
    var path: String { get }
    
    //var method: CCHTTPMethod { get }
    var parameter: [String: Any] { get }
    associatedtype Response
    
    /// 使用SwiftyJSON 进行解析 返回一个model数组，适用于列表显示
    func JSONParse(value: JSON) -> [Response?]?
}

extension CCRequest {
    func JSONParse(value: JSON) -> [Response?]? {
        return nil
    }
}

private func getHttpBodyString(_ parameters: [String: Any]) ->String {
    var list = Array<String>()
    for subDic in parameters {
        let tmpStr = "\(subDic.key)=\(subDic.value)"
        list.append(tmpStr)
    }
    //用&拼接变成字符串的字典各项
    let paramStr = list.joined(separator: "&")
    return paramStr
}
