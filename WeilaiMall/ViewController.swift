//
//  ViewController.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/2/23.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = CCbackgroundColor
        if (navigationController?.viewControllers.count)! > 1 {
            addBackItem()
        }
    }
    
    func addBackItem() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "back_icon")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(backAction(_:)))
    }
    
    func configWebView(requestUrl: String) -> WKWebView {
        let webview = WKWebView(frame: CGRect.zero, configuration: WKWebViewConfiguration.init())
        webview.load(URLRequest.init(url: URL.init(string: "http://139.196.124.0/#/"+requestUrl)!))
        return webview
    }
    
    @objc private func backAction(_ item: UIBarButtonItem) {
        _ = self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


