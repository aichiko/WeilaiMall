//
//  CCRequest.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/2/28.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import Foundation
import SwiftyJSON

//也可以为 URLSessionClient 添加一个单例来减少请求时的创建开销
struct URLSessionClient: Client {
    let host = "http://115.231.9.202:8080/24/web/study/"
    
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
    
    /*
     internal func alamofireSend<T : CCRequest>(_ r: T, handler: @escaping ([T.Response?], Error?) -> Void) {
     let url = URL(string: host.appending(r.path))!
     Alamofire.request(url, method: .post, parameters: r.parameter).responseJSON { (response) in
     debugPrint("data === \(response.data)")
     if response.result.isSuccess {
     let value = JSON(response.result.value!)
     debugPrint("value ==== \(value)")
     if let res = r.JSONParse(jsonData: value["data"]) {
     DispatchQueue.main.async { handler(res, response.result.error) }
     }
     }else {
     NSLog("error === \(response.result.error)")
     DispatchQueue.main.async { handler([], response.result.error) }
     }
     }
     }
     */
}



protocol Decodable {
    /// 返回一个model
    //func parse(data: Data) -> Self?
}

protocol Client {
    var host: String { get }
    func send<T: CCRequest>(_ r: T, handler: @escaping([T.Response?], Error?) -> Void)
    //    func alamofireSend<T: CCRequest>(_ r: T, handler: @escaping([T.Response?], Error?) -> Void)
}

enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
}

protocol CCRequest {
    var path: String { get }
    
    var method: HTTPMethod { get }
    var parameter: [String: Any] { get }
    associatedtype Response
    
    /// 返回一个model数组，适用于列表显示
    func parse(data: Data) -> [Response?]?
    
    /// 使用SwiftyJSON 进行解析 返回一个model数组，适用于列表显示
    func JSONParse(jsonData: JSON) -> [Response?]?
}

private func getHttpBodyString(_ parameters: [String: Any]) ->String {
    var list = Array<String>()
    for subDic in parameters {
        let tmpStr = "\(subDic.0)=\(subDic.1)"
        list.append(tmpStr)
    }
    //用&拼接变成字符串的字典各项
    let paramStr = list.joined(separator: "&")
    return paramStr
}
