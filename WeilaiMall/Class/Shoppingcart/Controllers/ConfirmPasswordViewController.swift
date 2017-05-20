//
//  ConfirmPasswordViewController.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/4/6.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit
import MBProgressHUD

/// 确认密码
class ConfirmPasswordViewController: ViewController {

    enum ConfirmStyle {
        case shopping(String, Int)
        case order(Int)
    }

    var style: ConfirmStyle = ConfirmStyle.order(0)
    
    @IBOutlet weak var textFieldView: UIView!
    
    @IBOutlet weak var textField: UITextField!
    
    var confirmButton: CCSureButton = CCSureButton.init("确认")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        configButton()
        
    }

    private func configButton() {
        self.view.addSubview(confirmButton)
        confirmButton.snp.updateConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.textFieldView.snp.bottom).offset(40)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(44)
        }
        confirmButton.buttonDisabled = false
        confirmButton.addTarget(self, action: #selector(confirmAction(button:)), for: .touchUpInside)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(textChange(_:)), name: .UITextFieldTextDidChange, object: nil)
        
    }
    
    func textChange(_ not: Notification) {
        confirmButton.buttonDisabled = (textField.text?.characters.count)! > 0
    }
    
    
    @objc private func confirmAction(button: UIButton) {
        switch style {
        case .shopping(let rec_id, let address_id):
            print(rec_id,address_id)
            shopConfirm(rec_id, address_id)
        case .order(let order_id):
            print(order_id)
            orderConfirmGoods(order_id)
        }
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


extension ConfirmPasswordViewController {
    /// 确认支付
    ///
    /// - Parameters:
    ///   - rec_id: 购物车ID
    ///   - address_id: 地址ID
    fileprivate func shopConfirm(_ rec_id: String, _ address_id: Int) {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        let password = textField.text
        let request = CarSuborderRequest(parameter: ["rec_id": rec_id, "access_token": access_token, "address_id": address_id, "pay_pass": password!])
        URLSessionClient().alamofireSend(request) { [weak self] (models, error) in
            hud.hide(animated: true)
            if error == nil {
                MBProgressHUD.showErrorAdded(message: "支付成功", to: self?.view)
                NotificationCenter.default.post(name: RefreshShoppingCart, object: nil)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                    self?.navigationController?.popToRootViewController(animated: true)
                })
            }else {
                MBProgressHUD.showErrorAdded(message: (error?.getInfo())!, to: self?.view)
            }
        }
    }
    
    /// 确认收货
    ///
    /// - Parameter order_id: 订单ID
    fileprivate func orderConfirmGoods(_ order_id: Int) {
        let password = textField.text
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        let request = OrderAffirmorderRequest(parameter: ["access_token": access_token, "order_id": order_id, "pay_pass": password!])
        
        URLSessionClient().alamofireSend(request) { [weak self] (models, error) in
            hud.hide(animated: true)
            if error == nil {
                MBProgressHUD.showErrorAdded(message: "确认收货", to: self?.view)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                    self?.navigationController?.popToRootViewController(animated: true)
                })
            }else {
                MBProgressHUD.showErrorAdded(message: (error?.getInfo())!, to: self?.view)
            }
        }
    }
    
}


