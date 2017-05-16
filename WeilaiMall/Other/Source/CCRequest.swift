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

/// 请求的风格
///
/// - refreshData: 刷新数据 index_page=1
/// - moreData: 加载更多数据 index_page+=1
enum CCRequestStyle {
    case refreshData
    case moreData
}

protocol CC_Error: Error {
    var status: Int { get }
    var info: String { get }
}

/*
 -1    	 系统繁忙，稍后再试
 0     	 处理成功
 1000    处理失败
 1001    access_token非法
 1002    sign验证失败
 1003    请求参数缺失
 */
struct RequestError: CC_Error {
    var info: String

    var status: Int

    init(status: Int, info: String?) {
        
        if status == 1000 && info == nil {
            self.status = status
            self.info = "处理失败"
        }else {
            self.status = status
            if let newinfo = info {
                self.info = newinfo
            }else {
                self.info = ""
            }
        }
        
    }
    
    init(status: Int) {
        self.init(status: status, info: nil)
    }
    
    func getInfo() -> String {
        
        switch status {
        case -1:
            return "系统繁忙，稍后再试"
        case 1000:
            return info
        case 1001:
            return "登录已失效，请重新登录！"
        case 1002:
            return "sign验证失败"
        case 1003:
            return "请求参数缺失"
        default:
            return "网络错误"
        }
    }
}

//也可以为 URLSessionClient 添加一个单例来减少请求时的创建开销
struct URLSessionClient: Client {

    let host = requestHost
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
            if response.result.isSuccess {
                let value = JSON(response.result.value!)
                
                let str = String.init(format: "requestUrl === %@\nparameter === %@\n", url, newDic)
                print(str)
                print(value)
                if value["status"].intValue == 0 {
                    print("请求成功")
                    if let models = r.JSONParse(value: value) {
                        DispatchQueue.main.async { handler(models, nil) }
                    }
                }else if value["status"].intValue == 1000 {
                    DispatchQueue.main.async { handler([], RequestError.init(status: value["status"].intValue, info: value["info"].stringValue)) }
                }else {
                    if value["status"].intValue == 1001 {
                        isLogin = false
                        NotificationCenter.default.post(name: ReloadHeadView, object: nil)
                        UserDefaults.init().setValue(false, forKey: "isLogin")
                    }
                    DispatchQueue.main.async { handler([], RequestError.init(status: value["status"].intValue)) }
                }
            }else {
                let str = String.init(format: "requestUrl === %@\nparameter === %@\n", url, newDic)
                NSLog("\(str)error === \(String(describing: response.result.error))")
                DispatchQueue.main.async { handler([], RequestError.init(status:-1000)) }
            }
        }
     }
}


/// 解析一个 Error
protocol DecodableError {
    /// 返回一个Error
    func parse(status: Int) -> Error?
}

extension DecodableError {
    func parse(status: Int) -> Error? {
        return RequestError.init(status: status)
    }
}

protocol Client {
    var host: String { get }
    func alamofireSend<T: CCRequest>(_ r: T, handler: @escaping([T.Response?], RequestError?) -> Void)
}

protocol CCRequest: DecodableError {
    var path: String { get }
    
    var parameter: [String: Any] { get }
    associatedtype Response
    /// 使用SwiftyJSON 进行解析 返回一个model数组，适用于列表显示
    func JSONParse(value: JSON) -> [Response?]?
}

extension CCRequest {
    
    //typealias Error = RequestError
    
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
