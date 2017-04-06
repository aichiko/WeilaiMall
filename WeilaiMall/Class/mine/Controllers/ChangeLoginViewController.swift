//
//  ChangeLoginViewController.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/3/8.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit
import MBProgressHUD

class ChangeLoginViewController: ViewController {

    @IBOutlet weak var oldTextField: UITextField!
    
    @IBOutlet weak var newTextField: UITextField!
    
    @IBOutlet weak var againTextField: UITextField!
    
    @IBOutlet weak var commitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        oldTextField.becomeFirstResponder()
        
        NotificationCenter.default.addObserver(self, selector: #selector(textChange(_:)), name: Notification.Name.UITextFieldTextDidChange, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func commitAction(_ sender: UIButton) {
        
        guard let newText = newTextField.text, let againText = againTextField.text, newText == againText else {
            MBProgressHUD.showErrorAdded(message: "两次输入的密码不一致", to: self.view)
            return
        }
        
        let oldText = oldTextField.text
        
        let request = UpdatePassRequest(parameter: ["access_token": access_token, "old_pass": oldText!, "new_pass": newText])
        URLSessionClient().alamofireSend(request) { [weak self] (messages, error) in
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

extension ChangeLoginViewController: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textChange(_ not: Notification) {
        buttonEnabled(enable: (oldTextField.text?.characters.count)!>0&&(newTextField.text?.characters.count)!>0&&(againTextField.text?.characters.count)!>0)
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        buttonEnabled(enable: (oldTextField.text?.characters.count)!>0&&(newTextField.text?.characters.count)!>0&&(againTextField.text?.characters.count)!>0)
        return true
    }
    
}


extension ChangeLoginViewController {
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
