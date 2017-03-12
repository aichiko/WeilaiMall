//
//  ChangeLoginViewController.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/3/8.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit

class ChangeLoginViewController: ViewController {

    @IBOutlet weak var oldTextField: UITextField!
    
    @IBOutlet weak var newTextField: UITextField!
    
    @IBOutlet weak var againTextField: UITextField!
    
    @IBOutlet weak var commitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addBackItem()
        
        oldTextField.becomeFirstResponder()
        
        NotificationCenter.default.addObserver(self, selector: #selector(textChange(_:)), name: Notification.Name.UITextFieldTextDidChange, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func commitAction(_ sender: UIButton) {
        
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
