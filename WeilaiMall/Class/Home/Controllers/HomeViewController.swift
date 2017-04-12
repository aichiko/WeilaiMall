//
//  HomeViewController.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/2/26.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit
import WebKit

class HomeViewController: ViewController, CCWebViewProtocol {

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

    var path: String = "local"
    
    var webView = WKWebView(frame: CGRect.zero, configuration: WKWebViewConfiguration.init())
    
    var leftItem = UIBarButtonItem()
    
    var rightItem = UIBarButtonItem()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //self.navigationItem.title = "首页"
        
        navigationAttribute()
        
        webView = configWebView(path: path)
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
        
        leftItem = UIBarButtonItem.init(image: UIImage.init(named: "scan_btn")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(scanCode(item:)))
        
        
        rightItem = UIBarButtonItem.init(image: UIImage.init(named: "catelog_icon")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(catelogShow(item:)))
        self.navigationItem.leftBarButtonItem = leftItem
        self.navigationItem.rightBarButtonItem = rightItem
        addSearchView()
    }
    
    func addSearchView() {
        let grayView = UIView()
        grayView.backgroundColor = UIColor(red:0.92, green:0.92, blue:0.92, alpha:1.00)
        grayView.layer.masksToBounds = true
        grayView.layer.cornerRadius = 15
        //addSubview(grayView)
        grayView.frame = CGRect(x: 0, y: 0, width: 300*self.view.bounds.width/375, height: 30)
        
        let searchIcon = UIImageView.init(image: UIImage.init(named: "search_icon"))
        grayView.addSubview(searchIcon)
        searchIcon.snp.updateConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(10)
        }
        
        grayView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(searchShow(tap:))))
        self.navigationItem.titleView = grayView
        
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
