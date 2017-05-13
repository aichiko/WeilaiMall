//
//  ClassifyViewController.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/2/26.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit
import WebKit
import MJRefresh

class ClassifyViewController: ViewController, CCWebViewProtocol {

    func push(path: String) {
        let controller = CCWebViewController()
        controller.path = path
        if path.hasPrefix("http") {
            // 传入完整的网址的情况下，直接打开相应的地址
            controller.requestURL = path
        }
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func pop(root: Bool = false) {
        if root {
            self.navigationController?.popToRootViewController(animated: true)
        }else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    var path: String = "classify"
    
    var webView = WKWebView(frame: CGRect.zero, configuration: WKWebViewConfiguration.init())
    lazy var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "分类"
        // Do any additional setup after loading the view.
        //webView = configWebView(path:path)
        
        let configuration = WKWebViewConfiguration()
        let userContent = WKUserContentController()
        userContent.add(self, name: "push")
        userContent.add(self, name: "pop")
        
        configuration.userContentController = userContent
        
        webView = WKWebView(frame: CGRect.zero, configuration: configuration)
        webView.load(URLRequest.init(url: URL.init(string: webViewHost+path)!))
        self.view.addSubview(webView)
        self.automaticallyAdjustsScrollViewInsets = false
        webView.snp.updateConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(64)
            make.bottom.equalTo(-48)
        }
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        if #available(iOS 10.0, *) {
            refreshControl.addTarget(self, action: #selector(refreshWebView), for: .valueChanged)
            webView.scrollView.refreshControl = refreshControl
        } else {
            // Fallback on earlier versions
            webView.scrollView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(refreshWebView))
        }
    }
    func refreshWebView() {
        webView.reloadFromOrigin()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        webView.configuration.userContentController.removeScriptMessageHandler(forName: "push")
        webView.configuration.userContentController.removeScriptMessageHandler(forName: "pop")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ClassifyViewController: WKScriptMessageHandler, WKNavigationDelegate, WKUIDelegate {
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "push" {
            //print(message.body)
            push(path: message.body as! String)
        }else if message.name == "pop" {
            //print(message.body)
            pop(root: message.body as? Bool ?? false)
        }
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if #available(iOS 10.0, *) {
            refreshControl.endRefreshing()
        } else {
            // Fallback on earlier versions
            webView.scrollView.mj_header.endRefreshing()
        }
    }
    
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        if #available(iOS 10.0, *) {
            refreshControl.endRefreshing()
        } else {
            // Fallback on earlier versions
            webView.scrollView.mj_header.endRefreshing()
        }
    }
}

