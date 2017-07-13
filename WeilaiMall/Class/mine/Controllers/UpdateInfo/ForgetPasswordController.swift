//
//  ForgetPasswordController.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/4/25.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit
import MBProgressHUD

class ForgetPasswordController: ViewController {

    
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var codeTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var codeButton: UIButton!
    
    @IBOutlet weak var commitButton: UIButton!
    
    var iscoding = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        phoneTextField.becomeFirstResponder()
        
        NotificationCenter.default.addObserver(self, selector: #selector(textChange(_:)), name: Notification.Name.UITextFieldTextDidChange, object: nil)
        
        buttonEnabled(enable: (phoneTextField.text?.characters.count)!>0&&(codeTextField.text?.characters.count)!>0&&(passwordTextField.text?.characters.count)!>0)
        codeEnabled(enable: (phoneTextField.text?.checkPhoneNumber())!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func codeAction(_ sender: Any) {
        func startTimer() {
            let queue = DispatchQueue.global()
            
            let source = DispatchSource.makeTimerSource(queue: queue)
            iscoding = true
            // deadline 结束时间
            // interval 时间间隔
            // leeway  时间精度
            source.scheduleRepeating(deadline: .now(), interval: 1, leeway: .nanoseconds(0))
            
            var timeout = 60    //倒计时时间
            
            //设置要处理的事件, 在我们上面创建的queue队列中进行执行
            codeButton.titleLabel?.adjustsFontSizeToFitWidth = true
            codeButton.isEnabled = false
            
            source.setEventHandler {
                
                print(Thread.current)
                if(timeout <= 1) {
                    source.cancel()
                } else {
                    print("\(timeout)s", Date())
                    timeout -= 1
                    
                    DispatchQueue.main.async {
                        
                        UIView.beginAnimations("22", context: nil)
                        UIView.setAnimationDuration(1)
                        self.codeButton.setTitle("重新获取(\(timeout))", for: .disabled)
                        //self.codeButton.titleLabel?.text = "重新获取(\(timeout))"
                        self.codeButton.backgroundColor = CCButtonGrayColor
                        UIView.commitAnimations()
                    }
                }
            }
            //倒计时结束的事件
            source.setCancelHandler {
                print("倒计时结束")
                DispatchQueue.main.async {
                    self.codeButton.isEnabled = true
                    self.codeButton.backgroundColor = CCOrangeColor
                    self.codeButton.setTitle("获取验证码", for: .disabled)
                }
                self.iscoding = false
            }
            source.resume()
        }
        
        guard (phoneTextField.text?.checkPhoneNumber())! else {
            MBProgressHUD.showErrorAdded(message: "请填写正确的手机号", to: self.view)
            return
        }
        startTimer()
        
        let request = ObtainCodeRequest(parameter: ["mobile_phone": phoneTextField.text!, "type": 2])
        URLSessionClient().alamofireSend(request) { [weak self] (str, error) in
            if (error != nil) {
                MBProgressHUD.showErrorAdded(message: (error?.getInfo())!, to: self?.view)
            }
        }
    }
    
    @IBAction func commitAction(_ sender: Any) {
        let hud = MBProgressHUD.showMessage(message: "", view: self.view)
        let request = FindPassRequest(parameter: ["code": codeTextField.text!, "mobile_phone": phoneTextField.text!, "new_pass": passwordTextField.text!])
        URLSessionClient().alamofireSend(request) { [weak self] (messages, error) in
            hud.hide(animated: true)
            if error == nil {
                if let message = messages[0] {
                    if message.status == 0 {
                        //修改成功，改掉本地的 access_token
                        access_token = message.access_token
                        MBProgressHUD.showErrorAdded(message: "修改成功", to: self?.view)
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                            self?.navigationController?.popViewController(animated: true)
                        })
                    }else {
                        if message.info.characters.count == 0 {
                            MBProgressHUD.showErrorAdded(message: (error?.getInfo())!, to: self?.view)
                        }else {
                            MBProgressHUD.showErrorAdded(message: message.info, to: self?.view)
                        }
                    }
                }
            }else {
                MBProgressHUD.showErrorAdded(message: (error?.getInfo())!, to: self?.view)
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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

extension ForgetPasswordController: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textChange(_ not: Notification) {
        buttonEnabled(enable: (phoneTextField.text?.characters.count)!>0&&(codeTextField.text?.characters.count)!>0&&(passwordTextField.text?.characters.count)!>0)
        
        if !iscoding {
            codeEnabled(enable: (phoneTextField.text?.checkPhoneNumber())!)
        }
    }
    
    func codeEnabled(enable: @autoclosure () -> Bool) {
        if enable() {
            codeButton.isEnabled = true
            codeButton.backgroundColor = CCOrangeColor
        }else {
            codeButton.isEnabled = false
            codeButton.backgroundColor = CCButtonGrayColor
        }
    }
    
    func buttonEnabled(enable: @autoclosure () -> Bool) {
        if enable() {
            commitButton.isEnabled = true
            commitButton.backgroundColor = CCOrangeColor
        }else {
            commitButton.isEnabled = false
            commitButton.backgroundColor = CCButtonGrayColor
        }
    }
    
}
