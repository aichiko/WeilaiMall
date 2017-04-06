//
//  ChangeUserInfoViewController.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/3/27.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit
import MBProgressHUD

class ChangeUserInfoViewController: ViewController {

    @IBOutlet weak var TextFieldView: UIView!
    
    @IBOutlet weak var textField: UITextField!
    
    typealias ChangeCallback = (_ real_name: String) -> Void
    
    var change: ChangeCallback?
    
    let button = CCSureButton.init("确定")
    
    var textFieldText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        configButton()
        
        NotificationCenter.default.addObserver(self, selector: #selector(textChange(not:)), name: .UITextFieldTextDidChange, object: nil)
    }
    
    
    private func configButton() {
        
        textField.text = textFieldText
        
        self.view.addSubview(button)
        
        button.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(40)
            make.top.equalTo(self.TextFieldView.snp.bottom).offset(20)
        }
        
        button.addTarget(self, action: #selector(sureAction(button:)), for: .touchUpInside)
        
        button.buttonDisabled = (textFieldText?.characters.count)! > 0
        textField.becomeFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        textField.endEditing(true)
    }
    
    @objc private func textChange(not: Notification) {
        if (textField.text?.characters.count)! > 0 {
            button.buttonDisabled = true
        }else {
            button.buttonDisabled = false
        }
    }
    
    @objc private func sureAction(button: UIButton) {
        
        if textFieldText == textField.text {
            //如果两个数值相等则说明没有修改，则直接返回
            _ = self.navigationController?.popViewController(animated: true)
            return
        }
        
        let real_name = textField.text!
        let request = UpdateInfoRequest(parameter: ["access_token": access_token, "real_name": real_name])
        let hub = MBProgressHUD.showAdded(to: self.view, animated: true)
        URLSessionClient().alamofireSend(request) { [weak self] (models, error) in
            hub.hide(animated: true)
            if error == nil {
                MBProgressHUD.showErrorAdded(message: "修改成功", to: self?.view)
                if self?.change != nil {
                    self?.change!(real_name)
                }
                do {
                    try CoreDataManager().updateUser(with: ["real_name": real_name])
                }catch {
                    MBProgressHUD.showErrorAdded(message: (error as NSError).domain , to: self?.view)
                }
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: { 
                    _ = self?.navigationController?.popViewController(animated: true)
                })
            }else {
                MBProgressHUD.showErrorAdded(message: (error?.getInfo())! , to: self?.view)
            }
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
