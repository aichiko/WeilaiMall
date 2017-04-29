//
//  SearchResultViewController.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/3/21.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit
import WebKit

class SearchResultViewController: ViewController {
    
    func push(path: String) {
        let controller = CCWebViewController()
        controller.path = path
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    lazy var searchBar = UISearchBar.init()
    
    var path = ""
    
    var resetSearchKey: ((String) -> Void)?
    
    var searchKey: String!
    
    var webView: WKWebView = WKWebView(frame: CGRect.zero, configuration: WKWebViewConfiguration.init())
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setWebView()
        
        navigationAttribute()
    }
    
    func setWebView() {
        let configuration = WKWebViewConfiguration()
        let userContent = WKUserContentController()
        userContent.add(self, name: "push")
        userContent.add(self, name: "pop")
        
        configuration.userContentController = userContent
        
        webView = WKWebView(frame: CGRect.zero, configuration: configuration)
        webView.load(URLRequest.init(url: URL.init(string: webViewHost+path + (path.contains("?") ?"&":"?") + "keyword="+searchKey)!))
        self.view.addSubview(webView)
        self.automaticallyAdjustsScrollViewInsets = false
        webView.snp.updateConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(64)
        }
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        print("RequestURL == ", webView.url?.description ?? "")
    }
    
    func navigationAttribute() {
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "back_icon")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(resultBackAction(_:)))
        
        searchBar.showsCancelButton = true
        searchBar.delegate = self
        
        self.navigationItem.titleView = searchBar
        searchBar.becomeFirstResponder()
        searchBar.text = searchKey
    }
    
    
    @objc private func resultBackAction(_ item: UIBarButtonItem) {
        if resetSearchKey != nil {
            resetSearchKey!(searchBar.text ?? "")
        }
        _ = self.navigationController?.popViewController(animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("\(self) deinit ")
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

extension SearchResultViewController: UISearchBarDelegate {
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if resetSearchKey != nil {
            resetSearchKey!(searchBar.text ?? "")
        }
        self.dismiss(animated: false, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let key = searchBar.text {
            searchKey = key
            webView.load(URLRequest.init(url: URL.init(string: webViewHost+path + (path.contains("?") ?"&":"?") + "keyword="+searchKey)!))
            webView.reload()
        }
        
        
    }
}

extension SearchResultViewController: WKScriptMessageHandler, WKNavigationDelegate, WKUIDelegate {
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "push" {
            print(message.body)
            push(path: message.body as! String)
        }else if message.name == "pop" {
            print(message.body)
            pop(root: message.body as? Bool ?? false)
        }
    }
}
