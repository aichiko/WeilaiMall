//
//  CCWebViewController.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/2/26.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit
import WebKit

/// web 页面
class CCWebViewController: ViewController {

    var webView = WKWebView(frame: CGRect.zero, configuration: WKWebViewConfiguration.init())
    
    var progress = UIProgressView(progressViewStyle: .default)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addBackItem()
        // Do any additional setup after loading the view.
        loadWebview()
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
        
        self.navigationController?.navigationBar.subviews.first?.addSubview(progress)
        progress.snp.updateConstraints { (make) in
            make.left.right.bottom.equalTo(0)
        }
        view.addSubview(webView)
        
        webView.snp.updateConstraints { (make) in
            make.edges.equalToSuperview()
        }
        webView.load(URLRequest.init(url: URL.init(string: "https://www.baidu.com")!))
        
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
        }
    }
    
}
