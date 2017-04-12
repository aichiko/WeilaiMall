//
//  ClassifyViewController.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/2/26.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit
import WebKit

class ClassifyViewController: ViewController, CCWebViewProtocol {

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
    
    var path: String = "classify"
    
    var webView = WKWebView(frame: CGRect.zero, configuration: WKWebViewConfiguration.init())
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "分类"
        // Do any additional setup after loading the view.
        webView = configWebView(path:path)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
