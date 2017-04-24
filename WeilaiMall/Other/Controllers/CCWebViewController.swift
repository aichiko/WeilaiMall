//
//  CCWebViewController.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/2/26.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit
import WebKit

protocol CCWebViewProtocol: NSObjectProtocol {
    var path: String { get set }
    
    /// 提供给H5 的push方法
    func push(path: String) -> Void
    /// 提供给H5 的pop方法
    func pop(root: Bool) -> Void
}


/// web 页面
class CCWebViewController: ViewController, CCWebViewProtocol {
    
    func push(path: String) {
        let controller = CCWebViewController()
        controller.path = path
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func pop(root: Bool = false) {
        if root {
            self.navigationController?.popToRootViewController(animated: true)
        }else {
            self.navigationController?.popViewController(animated: true)
        }
    }

    var webView = WKWebView(frame: CGRect.zero, configuration: WKWebViewConfiguration.init())
    
    var progress = UIProgressView(progressViewStyle: .bar)
    
    var path: String = ""
    
    /// 一个是通过 code扫描出来的网址进入，一个是根据path来进入
    var requestURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        loadWebview()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "back_icon")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(webViewBackAction(_:)))
    }
    
    func webViewBackAction(_ item: UIBarButtonItem) {
        if webView.canGoBack {
            webView.goBack()
        }else {
            self.pop()
        }
    }
    
    func closeAction() {
        _ = self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: "loading")
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        webView.removeObserver(self, forKeyPath: "title")
        progress.removeFromSuperview()
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

extension CCWebViewController {
    fileprivate func loadWebview() {
        
        let configuration = WKWebViewConfiguration()
        let userContent = WKUserContentController()
        userContent.add(self, name: "push")
        userContent.add(self, name: "pop")
        
        configuration.userContentController = userContent
        webView = WKWebView(frame: CGRect.zero, configuration: configuration)
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        self.navigationController?.navigationBar.subviews.first?.addSubview(progress)
        progress.snp.updateConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(2)
        }
        view.addSubview(webView)
        
        webView.snp.updateConstraints { (make) in
            make.edges.equalToSuperview()
        }
        if requestURL != nil {
            webView.load(URLRequest.init(url: URL.init(string: requestURL!)!))
        }else {
            
            webView.load(URLRequest.init(url: URL.init(string: webViewHost+path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!))
        }
        
        webView.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "title", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath=="estimatedProgress" {
            DispatchQueue.main.async {
                self.progress.setProgress(change?[NSKeyValueChangeKey.newKey] as! Float, animated: true)
            }
            self.progress.isHidden = (change?[NSKeyValueChangeKey.newKey] as! Float) == 1
        }else if keyPath == "title" {
            self.navigationItem.title = self.webView.title;
        }else if keyPath == "loading" {
            if self.navigationItem.leftBarButtonItems!.count == 1 {
                if webView.canGoBack {
                    updateNavigationItems()
                }
            }
        }
    }
    
    func updateNavigationItems() {
        
        let backItem = UIBarButtonItem.init(image: UIImage.init(named: "")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(webViewBackAction(_:)))
        
        let closeItem = UIBarButtonItem.init(title: "关闭", style: .plain, target: self, action: #selector(closeAction))
        closeItem.tintColor = UIColor.black
        
        self.navigationItem.leftBarButtonItems = [backItem, closeItem]
    }
    
}

extension CCWebViewController: WKScriptMessageHandler, WKNavigationDelegate, WKUIDelegate {
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "push" {
            print(message.body)
            push(path: message.body as! String)
        }else if message.name == "pop" {
            print(message.body)
            pop(root: message.body as! Bool)
        }
    }
}
