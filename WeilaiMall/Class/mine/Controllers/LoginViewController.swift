//
//  LoginViewController.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/2/28.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit

class LoginButton : UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        buttonAttribute()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
        buttonAttribute()
    }
    
    private func buttonAttribute() {
        
    }
}

/// 登录 页面
class LoginViewController: ViewController {

    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var userTextField: UITextField!
    
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var passwordTextFeild: UITextField!
    
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        subviewsAttribute()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginAction(_ sender: Any) {
        guard let user = userTextField.text else {
            print("账号密码不可为空")
            return
        }
        guard let password = passwordTextFeild.text else {
            print("账号密码不可为空")
            return
        }
        
        let request = LoginRequest(parameter: ["mobile_phone": user, "password": password])
        URLSessionClient().alamofireSend(request) { (models, error) in
            if error == nil {
                
            }else {
                print((error?.info())!)
            }
        }
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

extension LoginViewController {
    
    /// 设置 控件属性
    func subviewsAttribute() {
        let leftview = UIView(frame: CGRect.init(x: 0, y: 0, width: 40, height: 20))
        let imageView1 = UIImageView.init(image: UIImage.init(named: "user_icon"))
        leftview.addSubview(imageView1)
        imageView1.center = leftview.center
        let rightview = UIView(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))

        let imageView2 = UIImageView.init(image: UIImage.init(named: "psw_icon"))
        rightview.addSubview(imageView2)
        imageView2.center = rightview.center
        
        userTextField.leftView = leftview
        passwordTextFeild.leftView = rightview
        userTextField.leftViewMode = .always
        passwordTextFeild.leftViewMode = .always
        
        userView.layer.masksToBounds = true
        userView.layer.borderWidth = 1
        userView.layer.borderColor = UIColor.white.cgColor
        passwordView.layer.masksToBounds = true
        passwordView.layer.borderWidth = 1
        passwordView.layer.borderColor = UIColor.white.cgColor
    }
}

extension LoginViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.isEqual(userTextField) {
            passwordTextFeild.becomeFirstResponder()
        } else {
            self.view.endEditing(true)
            print("登录")
        }
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
}
