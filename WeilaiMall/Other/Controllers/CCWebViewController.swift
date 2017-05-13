//
//  CCWebViewController.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/2/26.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit
import WebKit
import SwiftyJSON
import MJRefresh
import MBProgressHUD

class BuyToolBar: UIToolbar {
    
    var shopcarBar = UIButton(type: .custom)
    
    var buyBar = UIButton(type: .custom)
    
    var shopcarNumBar = UIButton(type: .custom)
    
    var numberLabel = UILabel()
    
    var pushcar: (() -> Void)?
    
    var buyGoods: ((Bool) ->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialization()
    }
    
    func initialization() {
        
        self.addSubview(shopcarNumBar)
        self.addSubview(shopcarBar)
        self.addSubview(buyBar)
        shopcarNumBar.backgroundColor = UIColor.white
        shopcarBar.backgroundColor = UIColor.colorWithString("#FFA526")
        buyBar.backgroundColor = CCOrangeColor
        
        shopcarNumBar.setImage(UIImage.init(named: "play_shopping"), for: .normal)
        
        shopcarBar.setTitle("加入购物车", for: .normal)
        shopcarBar.setTitleColor(UIColor.white, for: .normal)
        shopcarBar.setTitleColor(UIColor.lightGray, for: .highlighted)
        shopcarBar.titleLabel?.font = UIFont.CCsetfont(14)
        shopcarBar.tag = 100
        buyBar.setTitle("立即购买", for: .normal)
        buyBar.setTitleColor(UIColor.white, for: .normal)
        buyBar.setTitleColor(UIColor.lightGray, for: .highlighted)
        buyBar.titleLabel?.font = UIFont.CCsetfont(14)
        buyBar.tag = 101
        
        shopcarNumBar.addTarget(self, action: #selector(gotoShopcar(_:)), for: .touchUpInside)
        shopcarBar.addTarget(self, action: #selector(buyAction(_:)), for: .touchUpInside)
        buyBar.addTarget(self, action: #selector(buyAction(_:)), for: .touchUpInside)
        
        shopcarNumBar.snp.updateConstraints { (make) in
            
            make.centerY.left.top.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(115.0/375.0)
        }
        
        shopcarBar.snp.updateConstraints { (make) in
            make.centerY.top.equalToSuperview()
            make.left.equalTo(shopcarNumBar.snp.right)
            make.width.equalToSuperview().multipliedBy(130.0/375.0)
        }
        
        buyBar.snp.updateConstraints { (make) in
            make.right.top.equalToSuperview()
            make.centerY.equalToSuperview()
            make.left.equalTo(shopcarBar.snp.right)
        }
        
        numberLabel.backgroundColor = CCOrangeColor
        numberLabel.layer.masksToBounds = true
        numberLabel.layer.cornerRadius = 7.5
        numberLabel.adjustsFontSizeToFitWidth = true
        numberLabel.text = "0"
        numberLabel.textColor = UIColor.white
        numberLabel.font = UIFont.CCsetfont(11)
        numberLabel.textAlignment = .center
        numberLabel.isHidden = numberLabel.text == "0"
        
        shopcarNumBar.addSubview(numberLabel)
        numberLabel.snp.updateConstraints { (make) in
            
            make.centerX.equalTo(shopcarNumBar.snp.centerX).offset(10)
            make.centerY.equalTo(shopcarNumBar.snp.centerY).offset(-10)
            make.width.height.equalTo(15)
        }
        
    }
    
    func gotoShopcar(_ button: UIButton) {
        if pushcar != nil {
            debugPrint("跳转到购物车")
            pushcar!()
        }
    }
    
    func buyAction(_ button: UIButton) {
        if buyGoods != nil {
            debugPrint("加入购物车和立即购买")
            buyGoods!(button.tag == 101)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


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
        if path.hasPrefix("http") {
            // 传入完整的网址的情况下，直接打开相应的地址
            controller.requestURL = path
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func pop(root: Bool = false) {
        if root {
            self.navigationController?.popToRootViewController(animated: true)
        }else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func showBuyToolbar(goods_id: String) {
        
        func addShopCart(goods_id: String, join: Bool) {
            guard isLogin else {
                return
            }
            let request = ShoppingCartAddRequest(parameter: ["access_token": access_token, "goods_id": goods_id, "goods_num": 1])
            let hud = MBProgressHUD.showMessage(message: "", view: self.view)
            URLSessionClient().alamofireSend(request) { [weak self] (models, error) in
                hud.hide(animated: true)
                if error == nil {
                    if models.count > 0, let number = models[0] {
                        if number == 0  {
                            self?.toolBar.numberLabel.isHidden = true
                        }else if number>9 {
                            self?.toolBar.numberLabel.isHidden = false
                            self?.toolBar.numberLabel.text = "9+"
                        }else {
                            self?.toolBar.numberLabel.isHidden = false
                            self?.toolBar.numberLabel.text = number.description
                        }
                    }
                    if join {
                        //立即购买后进入购物车页面
                        let shopVC = ShoppingCartViewController()
                        shopVC.noTabbar = false
                        self?.navigationController?.pushViewController(shopVC, animated: true)
                    }else{
                        MBProgressHUD.showErrorAdded(message: "添加成功", to: self?.view)
                    }
                }else {
                    MBProgressHUD.showErrorAdded(message: (error?.getInfo())!, to: self?.view)
                }
            }
        }
        
        func shopCartNum() {
            
            guard isLogin else {
                return
            }
            
            let request = ShoppingCartNumRequest(parameter: ["access_token": access_token])
            URLSessionClient().alamofireSend(request) { [weak self] (models, error) in
                if error == nil {
                    if models.count > 0, let number = models[0] {
                        if number == 0  {
                            self?.toolBar.numberLabel.isHidden = true
                        }else if number>9 {
                            self?.toolBar.numberLabel.isHidden = false
                            self?.toolBar.numberLabel.text = "9+"
                        }else {
                            self?.toolBar.numberLabel.isHidden = false
                            self?.toolBar.numberLabel.text = number.description
                        }
                    }
                }else {
                    MBProgressHUD.showErrorAdded(message: (error?.getInfo())!, to: self?.view)
                }
            }
        }
        
        self.view.addSubview(toolBar)
        toolBar.snp.updateConstraints { (make) in
            make.bottom.equalTo(44)
            make.left.right.equalToSuperview()
            make.height.equalTo(0)
        }
        self.view.layoutIfNeeded()
        toolBar.snp.updateConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(44)
        }
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
        UIView.animate(withDuration: 0.2, animations: { 
            self.view.layoutIfNeeded()
        }) { (complete) in
            self.webView.snp.updateConstraints({ (make) in
                make.bottom.equalTo(-44)
            })
        }
        shopCartNum()
        
        toolBar.pushcar = {
            [weak self] in
            guard isLogin else {
                let loginVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "login")
                self?.navigationController?.pushViewController(loginVC, animated: true)
                return
            }
            let shopVC = ShoppingCartViewController()
            shopVC.noTabbar = false
            self?.navigationController?.pushViewController(shopVC, animated: true)
        }
        
        toolBar.buyGoods = {
            [weak self] join in
            
            guard isLogin else {
                let loginVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "login")
                self?.navigationController?.pushViewController(loginVC, animated: true)
                return
            }
            
            addShopCart(goods_id: goods_id, join: join)
        }
        
        
    }

    lazy var toolBar = BuyToolBar(frame: CGRect.zero)
    
    var webView = WKWebView(frame: CGRect.zero, configuration: WKWebViewConfiguration.init())
    
    var progress = UIProgressView(progressViewStyle: .bar)
    
    var path: String = ""
    
    var address: ((ShoppingCartAdress) -> Void)?
    
    lazy var refreshControl = UIRefreshControl()
    
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
        webView.configuration.userContentController.removeScriptMessageHandler(forName: "address")
        webView.configuration.userContentController.removeScriptMessageHandler(forName: "goods_buy")
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
        
        userContent.add(self, name: "goods_buy")
        
        if path.contains("address") {
            userContent.add(self, name: "address")
        }
        
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
        
        self.automaticallyAdjustsScrollViewInsets = false
        webView.snp.updateConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(64)
        }
        if requestURL != nil {
            webView.load(URLRequest.init(url: URL.init(string: requestURL!.replacingOccurrences(of: " ", with: ""))!))
        }else {
            webView.load(URLRequest.init(url: URL.init(string: webViewHost+path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!))
        }
        
        debugPrint(webView.url!)
        
        webView.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "title", options: .new, context: nil)
        
        if #available(iOS 10.0, *) {
            refreshControl.addTarget(self, action: #selector(refreshWebView), for: .valueChanged)
            webView.scrollView.refreshControl = refreshControl
        } else {
            // Fallback on earlier versions
            webView.scrollView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(refreshWebView))
        }
    }
    
    func refreshWebView() {
        self.progress.setProgress(0, animated: false)
        webView.reloadFromOrigin()
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
        
        let backItem = UIBarButtonItem.init(image: UIImage.init(named: "back_icon")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(webViewBackAction(_:)))
        
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
            pop(root: message.body as? Bool ?? false)
        }else if message.name == "address" {
            print(message.body)
            if let dic = message.body as? [String: Any] {
                print(dic)
                if address != nil {
                    let value = JSON(dic)
                    let model = ShoppingCartAdress(value: value)
                    guard model != nil else {
                        MBProgressHUD.showErrorAdded(message: "地址为空", to: self.view)
                        return
                    }
                    address!(model!)
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }else if message.name == "goods_buy" {
            showBuyToolbar(goods_id: message.body as? String ?? "")
        }
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.progress.setProgress(0, animated: false)
        if #available(iOS 10.0, *) {
            refreshControl.endRefreshing()
        } else {
            // Fallback on earlier versions
            webView.scrollView.mj_header.endRefreshing()
        }
    }
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.progress.setProgress(0, animated: false)
        if #available(iOS 10.0, *) {
            refreshControl.endRefreshing()
        } else {
            // Fallback on earlier versions
            webView.scrollView.mj_header.endRefreshing()
        }
    }
}
