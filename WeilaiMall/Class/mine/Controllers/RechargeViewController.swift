//
//  RechargeViewController.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/3/15.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit
import MBProgressHUD
import SwiftyJSON
import StoreKit

/// 充值 页面
class RechargeViewController: ViewController {

    var tableView = UITableView.init(frame: CGRect.zero, style: .grouped)
    let cellIdentifier = "RechargeCell"
    let button: CCSureButton = CCSureButton.init("确认充值")
    
    let titles: [String] = ["充值金额", "支付方式"]
    
    /// 订单号
    var out_trade_no = ""
    
    typealias refreshData = () -> Void
    
    var refresh: refreshData?
    
    let textField = UITextField.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        configTableView()
        
        prepareData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ALIPayResultAction(notification:)), name: ALIPayResult, object: nil)
    }
    
    private func prepareData() {
        URLSessionClient().alamofireSend(UserBalanceRequest(parameter: ["access_token": access_token]),  handler: { [weak self] (models, error) in
            if error == nil {
                
            }else {
                MBProgressHUD.showErrorAdded(message: (error?.getInfo())!, to: self?.view)
            }
        })
    }
    
    
    private func configTableView() {
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        tableView.snp.updateConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        tableView.addSubview(button)
        
        button.snp.updateConstraints { (make) in
            make.top.equalTo(150)
            make.centerX.equalToSuperview()
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(44)
        }
        
        button.addTarget(self, action: #selector(rechargeAction(_:)), for: .touchUpInside)
        
    }
    
    @objc private func rechargeAction(_ button: CCSureButton) {
        print("充值！！！")
        buyAction()
    }

    
    @objc  fileprivate func hideKeyborad() {
        self.view.endEditing(true)
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

extension RechargeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        func configTextField(cell: UITableViewCell?) {
            
            /// 增加 inputAccessoryView 方便键盘的回收
            func addInputView(textField: UITextField) {
                let accessoryView = UIView()
                accessoryView.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.00)
                accessoryView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40)
                textField.inputAccessoryView = accessoryView
                
                let blurEffect = UIBlurEffect.init(style: UIBlurEffectStyle.extraLight)
                let visualEffectView = UIVisualEffectView.init(effect: blurEffect)
                visualEffectView.frame = accessoryView.bounds
                accessoryView.addSubview(visualEffectView)
                
                let completionButton = UIButton.init(type: .custom)
                completionButton.setTitle("完成", for: .normal)
                completionButton.titleLabel?.font = UIFont.CCsetfont(15, nil)
                completionButton.setTitleColor(UIColor(red:0.99, green:0.25, blue:0.00, alpha:1.00), for: .normal)
                completionButton.setTitleColor(UIColor.lightGray, for: .highlighted)
                accessoryView.addSubview(completionButton)
                
                completionButton.snp.updateConstraints { (make) in
                    make.right.top.equalToSuperview()
                    make.centerY.equalTo(accessoryView)
                    make.height.equalTo(40)
                    make.width.equalTo(60)
                }
                
                completionButton.addTarget(self, action: #selector(hideKeyborad), for: .touchUpInside)
            }
            
            
            if indexPath.row == 0 {
                cell?.contentView.addSubview(textField)
                textField.keyboardType = .decimalPad
                textField.tag = 222
                textField.font = UIFont.CCsetfont(16)
                textField.placeholder = "300"
                textField.snp.updateConstraints({ (make) in
                    make.left.equalTo((cell?.textLabel?.snp.right)!).offset(10)
                    make.right.equalTo(-10)
                    make.height.equalToSuperview()
                })
                textField.isEnabled = WXApi.isWXAppInstalled()
                addInputView(textField: textField)
            }
        }
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell.init(style: .value1, reuseIdentifier: cellIdentifier)
            cell?.accessoryType = indexPath.row == 0 ?.none:.disclosureIndicator
            
            configTextField(cell: cell)
        }
        cell?.textLabel?.text = titles[indexPath.row]
        cell?.detailTextLabel?.text = indexPath.row == 0 ?nil:"支付宝"
        cell?.selectionStyle = .none
        return cell!
    }
}

extension RechargeViewController {
    
    struct CCPaySuccessReuest: CCRequest {
        let path: String = checkpay
        
        var parameter: [String: Any]
        typealias Response = String
        
        func JSONParse(value: JSON) -> [String?]? {
            return [""]
        }
    }
    
    struct CCALiPaymentRequest: CCRequest {
        
        struct AliPayment {
            /// 订单号
            var out_trade_no: String
            /// 支付商品总价
            var total_amount: Float
            /// 支付宝appid
            var appid: String
            /// 支付商品详细内容
            var body: String
            /// 商户回调地址
            var notify_url: String
            /// 支付宝私钥
            var privateKey: String
            /// 支付商品标题
            var subject: String
            
            init(value: JSON) {
                out_trade_no = value["out_trade_no"].stringValue
                total_amount = value["total_amount"].floatValue
                appid = value["appid"].stringValue
                body = value["body"].stringValue
                notify_url = value["notify_url"].stringValue
                privateKey = value["privateKey"].stringValue
                subject = value["subject"].stringValue
            }
        }
        
        let path: String = recharge
        
        var parameter: [String: Any]
        typealias Response = AliPayment
        
        func JSONParse(value: JSON) -> [AliPayment?]? {
            return [AliPayment.init(value: value["data"])]
        }
    }
    
    func buyAction() {
        
        var amount: Float = 0
        if let textField = view.viewWithTag(222) as? UITextField {
            if textField.text == "" {
                amount = Float(textField.placeholder ?? "0")! >= 0.01 ?Float(textField.placeholder ?? "0")!:0
            }else {
                amount = Float(textField.text ?? "0")! >= 0.01 ?Float(textField.text ?? "0")!:0
            }
        }
        guard amount > 0 else {
            MBProgressHUD.showErrorAdded(message: "充值金额不能少于0.01", to: self.view)
            return
        }
        
        if WXApi.isWXAppInstalled() {
            let hud = MBProgressHUD.showMessage(message: "", view: self.view)
            let request = CCALiPaymentRequest(parameter: ["amount": String.init(format: "%.2f", amount), "access_token": access_token])
            URLSessionClient().alamofireSend(request) { [weak self] (models, error) in
                hud.hide(animated: true)
                if error == nil {
                    if models.count > 0 {
                        if let model = models[0] {
                            self?.aliPayAction(model: model)
                        }
                    }
                }else {
                    MBProgressHUD.showErrorAdded(message: (error?.getInfo())!, to: self?.view)
                }
            }
        }else{
            IAPPayAction()
        }
    }
    
    func aliPayAction(model: CCALiPaymentRequest.AliPayment) {
        self.out_trade_no = model.out_trade_no
        
        /*============================================================================*/
        /*=======================需要填写商户app申请的===================================*/
        /*============================================================================*/
        let appID = model.appid;
        let privateKey = model.privateKey
        //partner和seller获取失败,提示
        if appID.characters.count == 0 || privateKey.characters.count == 0 {
            MBProgressHUD.showErrorAdded(message: "缺少appId或者私钥。", to: self.view)
            return
        }
        /*
         *生成订单信息及签名
         */
        //将商品信息赋予AlixPayOrder的成员变量
        let order = Order.init()
        // NOTE: app_id设置
        order.app_id = appID;
        
        // NOTE: 支付接口名称
        order.method = "alipay.trade.app.pay";
        
        // NOTE: 参数编码格式
        order.charset = "utf-8";
        
        // NOTE: 当前时间点
        let formatter = DateFormatter.init()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        order.timestamp = formatter.string(from: Date.init())
        
        // NOTE: 支付版本
        order.version = "1.0";
        
        // NOTE: sign_type设置
        order.sign_type = "RSA2";
        
        order.notify_url = model.notify_url //回调URL
        
        // NOTE: 商品数据
        order.biz_content = BizContent.init()
        order.biz_content.body = model.body //商品描述
        order.biz_content.subject = model.subject //商品标题
        order.biz_content.out_trade_no = model.out_trade_no //订单ID（由商家自行制定）
        order.biz_content.timeout_express = "30m"; //超时时间设置
        order.biz_content.total_amount = String.init(format: "%.2f", model.total_amount) //商品价格
        
        //将商品信息拼接成字符串
        let orderInfo = order.orderInfoEncoded(false)
        let orderInfoEncoded = order.orderInfoEncoded(true)
        print("orderSpec = \(orderInfo!)");
        //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
        let appScheme = "WeilaiMall";
        
        // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
        //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
        
        let signer = RSADataSigner.init(privateKey: privateKey)
        let signedString = signer?.sign(orderInfo, withRSA2: true)
        
        if (signedString != nil) {
            // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
            let orderString = String.init(format: "%@&sign=%@", orderInfoEncoded!, signedString!)
            
            print("orderString = \(orderString)")
            
            AlipaySDK.defaultService().payOrder(orderString, fromScheme: appScheme, callback: { [unowned self] (resultDic) in
                //windowtemp.hidden = YES;
                print("reslut = %@",resultDic!)
                self.changeOrderStatus(with: resultDic?["resultStatus"] as? Int ?? 4000)
            })
        }
    }
    
    func ALIPayResultAction(notification: Notification) {
        if let resultDic = notification.userInfo?["response"] as? [String: Any] {
            changeOrderStatus(with: Int.init(resultDic["resultStatus"] as! String) ?? 4000)
        }
    }
    
    
    /*
     9000	订单支付成功
     8000	正在处理中
     4000	订单支付失败
     6001	用户中途取消
     6002	网络连接出错
     */
    /**
     *  收到支付宝返回的状态，支付成功则调用接口更改订单状态，并且返回播放界面。支付失败则停留在订单界面
     *
     *  @param orderStatus 支付状态，详情见上表
     */
    func changeOrderStatus(with orderStatus: Int) {
        
        func isPaySuccess() {
            
            if out_trade_no == "" {
                MBProgressHUD.showErrorAdded(message: "订单号错误", to: self.view)
                return
            }
            
            let request = CCPaySuccessReuest(parameter: ["access_token": access_token, "out_trade_no": out_trade_no])
            URLSessionClient().alamofireSend(request) { [weak self] (models, error) in
                if error == nil {
                    MBProgressHUD.showErrorAdded(message: "充值成功", to: self?.view)
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                        _ = self?.navigationController?.popViewController(animated: true)
                        if self?.refresh != nil {
                            self?.refresh!()
                        }
                    })
                }else {
                    MBProgressHUD.showErrorAdded(message: (error?.getInfo())!, to: self?.view)
                }
            }
        }
        
        switch orderStatus {
        case 9000:
            isPaySuccess()
        case 4000:
            MBProgressHUD.showErrorAdded(message: "支付失败", image: "pay_failed", to: self.view)
        case 6001:
            MBProgressHUD.showErrorAdded(message: "取消支付", image: "pay_failed", to: self.view)
        case 6002:
            MBProgressHUD.showErrorAdded(message: "网络连接出错", image: "pay_failed", to: self.view)
        case 8000:
            MBProgressHUD.showErrorAdded(message: "取消支付", image: "pay_failed", to: self.view)
        default:
            return
        }
    }
}


// MARK: - SKProductsRequestDelegate, SKPaymentTransactionObserver
extension RechargeViewController: SKProductsRequestDelegate, SKPaymentTransactionObserver {
    @available(iOS 3.0, *)
    
    func IAPPayAction() {
        //先询问用户是否允许应用内支付
        if SKPaymentQueue.canMakePayments() {
            let set: Set<String> = Set.init(["weilai"])
            let request =  SKProductsRequest.init(productIdentifiers: set)
            request.delegate = self;
            request.start()
        }else {
            print("失败，用户禁止应用内付费购买.")
        }
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        //保存有效的产品
        NSLog("--------------收到产品反馈消息---------------------");
        let product = response.products;
        if product.count == 0{
            NSLog("--------------没有商品------------------");
            return;
        }
        
        NSLog("productID:%@", response.invalidProductIdentifiers);
        NSLog("产品付费数量:%ld",product.count);
        
        var p = SKProduct.init();
        for pro in product {
            NSLog("%@", pro.description);
            NSLog("%@", pro.localizedTitle);
            NSLog("%@", pro.localizedDescription);
            NSLog("%@", pro.price);
            NSLog("%@", pro.productIdentifier);
            
            if pro.productIdentifier == "weilai"{
                p = pro;
            }
        }
        
        let payment = SKPayment.init(product: p)
        NSLog("发送购买请求");
        SKPaymentQueue.default().add(payment)
    }
    
    
    func requestDidFinish(_ request: SKRequest) {
        NSLog("请求完成.");
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        NSLog("请求过程中发生错误，错误信息：%@",error.localizedDescription);
    }
    
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState
            {
            case .purchased://交易完成
                NSLog("transactionIdentifier = %@", transaction.transactionIdentifier!);
                //交易完成修改订单状态
                completeTransaction(transaction: transaction)
            case .failed://交易失败
                //[self.hub hide:YES];
                failedTransaction(transaction: transaction)
                break
            case .restored://已经购买过该商品
                restoreTransaction(transaction: transaction)
                break
            case .purchasing:      //商品添加进列表
                NSLog("商品添加进列表");
                break;
            default:
                break;
            }
        }
    }
    
    func completeTransaction(transaction: SKPaymentTransaction) {
        // Your application should implement these two methods.
        let productIdentifier = transaction.payment.productIdentifier;
        NSLog("%@",productIdentifier);
        //NSString * receipt = [transaction.transactionReceipt base64EncodedString];
        if (productIdentifier.characters.count > 0) {
            // 向自己的服务器验证购买凭证
            let alertController = UIAlertController.init(title: "", message: "支付成功", preferredStyle: .alert)
            let suerAction = UIAlertAction.init(title: "确定", style: .default, handler: { (userAction) in
                //self.changeOrderStatus(with: 9000)
            })
            alertController.addAction(suerAction)
            
        }
        // Remove the transaction from the payment queue.
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    
    func failedTransaction(transaction: SKPaymentTransaction) {
        if transaction.error != nil {
            MBProgressHUD.showErrorAdded(message: "购买失败", image: "pay_failed", to: self.view)
            SKPaymentQueue.default().finishTransaction(transaction)
        }
    }
    
    func restoreTransaction(transaction: SKPaymentTransaction) {
        // 对于已购商品，处理恢复购买的逻辑
        SKPaymentQueue.default().finishTransaction(transaction)
    }
}


