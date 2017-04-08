//
//  HomeViewController.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/2/26.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit
import WebKit

class HomeViewController: ViewController {

    var webView = WKWebView(frame: CGRect.zero, configuration: WKWebViewConfiguration.init())
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //self.navigationItem.title = "首页"
        
        navigationAttribute()
        
        
        webView = configWebView(requestUrl:"local")
        
        self.view.addSubview(webView)
        webView.snp.updateConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "scanCode" {
            let controller = segue.destination as! ScanCodeViewController
            controller.codeMessage = {
                message in
                let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
                let action = UIAlertAction(title: "done", style: .default, handler: nil)
                alertController.addAction(action)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
        
    }

}

extension HomeViewController {
    func navigationAttribute() {
        
        let leftItem = UIBarButtonItem.init(image: UIImage.init(named: "scan_btn")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(scanCode(item:)))
        
        
        let rightItem = UIBarButtonItem.init(image: UIImage.init(named: "catelog_icon")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(catelogShow(item:)))
        
        self.navigationItem.leftBarButtonItem = leftItem
        self.navigationItem.rightBarButtonItem = rightItem
        
        let grayView = UIView()
        grayView.backgroundColor = UIColor(red:0.92, green:0.92, blue:0.92, alpha:1.00)
        grayView.layer.masksToBounds = true
        grayView.layer.cornerRadius = 15
        navigationController?.navigationBar.addSubview(grayView)
        
        grayView.snp.updateConstraints { (make) in
            make.center.equalToSuperview()
            make.left.equalTo(50)
            make.right.equalTo(-50)
            make.height.equalTo(30)
        }
        
        let searchIcon = UIImageView.init(image: UIImage.init(named: "search_icon"))
        grayView.addSubview(searchIcon)
        searchIcon.snp.updateConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(10)
        }
        
        grayView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(searchShow(tap:))))
    }
    
    @objc private func scanCode(item: UIBarButtonItem) {
        self.performSegue(withIdentifier: "scanCode", sender: self)
    }
    
    @objc private func catelogShow(item: UIBarButtonItem) {
        
    }
    
    @objc private func searchShow(tap: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "home_search", sender: self)
    }
}
