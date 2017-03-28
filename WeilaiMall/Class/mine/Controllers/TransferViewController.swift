//
//  TransferViewController.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/3/12.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit
import MBProgressHUD

class CCSureButton: UIButton {
    
    let title: String
    
    var buttonDisabled = true {
        didSet {
            isEnabled = buttonDisabled
            self.backgroundColor = buttonDisabled ?CCOrangeColor:CCButtonGrayColor
        }
    }
    
    init(_ title: String) {
        
        self.title = title
        super.init(frame: CGRect.zero)
        setButton()
    }
    
    private func setButton() {
        self.backgroundColor = CCOrangeColor
        self.setTitle(self.title, for: .normal)
        setTitleColor(UIColor.white, for: .normal)
        setTitleColor(UIColor.lightGray, for: .highlighted)
        setTitleColor(UIColor.black, for: .disabled)
        titleLabel?.font = UIFont.CCsetfont(14)
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 4
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


/// 转账
class TransferViewController: ViewController {

    let cellIdentifier = "TransferCell"
    
    var tableView = UITableView(frame: CGRect.zero, style: .grouped)
    
    let nextButton: CCSureButton = CCSureButton.init("确定转账")
    
    let celltexts = ["对方账号", "真实姓名", "转账积分", "支付密码"]
    let placeholders = ["请输入对方手机号", "请输入真实姓名", "请输入转账积分", "请输入支付密码"]
    
    /// 是否验证 转账前需要先填写用户手机号，确认后才能进行后续的转账
    var isVerification = false
    
    /// 已经验证的手机号， 如果用户更改了验证的手机号，则需要重新验证
    var verificatedPhone: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configTableView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(textChange(not:)), name: .UITextFieldTextDidChange, object: nil)
    }
    
    @objc private func textChange(not: Notification) {
        let cell1 = tableView.cellForRow(at: IndexPath.init(row: 2, section: 0)) as! TextFieldTableViewCell
        let cell2 = tableView.cellForRow(at: IndexPath.init(row: 0, section: 1)) as! TextFieldTableViewCell
        
        if (cell1.textField.text?.characters.count)! > 0 && (cell2.textField.text?.characters.count)! > 0   {
            nextButton.buttonDisabled = true
        }else {
            nextButton.buttonDisabled = false
        }
    }
    
    private func configTableView() {
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        tableView.snp.updateConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        tableView.addSubview(nextButton)
        nextButton.buttonDisabled = false
        nextButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(40)
            make.top.equalTo(260)
        }
        
        nextButton.addTarget(self, action: #selector(transferAction(_:)), for: .touchUpInside)
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

extension TransferViewController: UITableViewDelegate, UITableViewDataSource {
    @available(iOS 2.0, *)
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UITableViewHeaderFooterView.init()
        let label = UILabel()
        if section == 1 {
            view.addSubview(label)
            label.font = CCTextFont
            label.textColor = UIColor(red:0.88, green:0.05, blue:0.00, alpha:1.00)
            label.text = "您最多可转账8000积分"
            label.snp.makeConstraints({ (make) in
                make.centerY.height.top.equalToSuperview()
                make.left.equalTo(15)
            })
        }else {
            label.removeFromSuperview()
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ?15: 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ?3:1
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        func getIndex() -> Int {
            if indexPath.section == 0 {
                return indexPath.row
            }else {
                var index: Int = 0
                for section in 0...indexPath.section-1 {
                    index += 1*tableView.numberOfRows(inSection: section)
                }
                return index
            }
        }
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? TextFieldTableViewCell
        if cell == nil {
            cell = TextFieldTableViewCell.init(cellText: (celltexts[getIndex()], placeholders[getIndex()]), reuseIdentifier: cellIdentifier)
            cell?.textField.tag = 100+getIndex()
            cell?.textField.delegate = self
            cell?.selectionStyle = .none
            if indexPath.section == 0 && indexPath.row == 1 {
                cell?.textField.removeFromSuperview()
            }
        }
        if indexPath.section == 1&&indexPath.row == 0 {
            cell?.textField.isSecureTextEntry = true
        }else {
            cell?.textField.isSecureTextEntry = false
        }
        if (indexPath.section == 0&&indexPath.row == 0) || (indexPath.section == 0 && indexPath.row == 2) {
            cell?.keyboradType = .numberPad
        }else {
            cell?.keyboradType = .default
        }
        return cell!
    }
}

extension TransferViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if !isVerification && textField.tag != 100 {
            MBProgressHUD.showErrorAdded(message: "请先验证手机号", to: self.view)
            textField.endEditing(true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.tag == 100 {
            // 点击完成后，验证手机号
            verificatePhone(phoneNum: textField.text!, textField: textField)
        }else if textField.tag == 102 {
            // 输入积分
            return valid(textField: textField)
        }
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 102 {
            // 输入积分 如果大于8000 则返回失败
            return valid(textField: textField)
        }
        return true
    }
    
    func valid(textField: UITextField) -> Bool {
        if let num = Float(textField.text!), num > 8000.0 {
            MBProgressHUD.showErrorAdded(message: "您最多可转账8000积分", to: self.view)
            return false
        }
        return true
    }
    
}

// MARK: - request
extension TransferViewController {
    
    func verificatePhone(phoneNum: String, textField: UITextField) {
        let request = VerificationRequest(parameter: ["access_token": access_token, "mobile_phone": phoneNum])
        URLSessionClient().alamofireSend(request) { [weak self] (models, error) in
            if error == nil {
                self?.isVerification = true
                self?.verificatedPhone = (models[0]?.real_name)!
                let cell = self?.tableView.cellForRow(at: IndexPath.init(row: 1, section: 0)) as! TextFieldTableViewCell
                cell.real_name = (models[0]?.real_name)!
                textField.isEnabled = false
            }else {
                MBProgressHUD.showErrorAdded(message: (error as! VerificateError).info(), to: self?.view)
            }
        }
    }
    
    
    @objc func transferAction(_ button: UIButton) {
        let cell1 = tableView.cellForRow(at: IndexPath.init(row: 2, section: 0)) as! TextFieldTableViewCell
        let cell2 = tableView.cellForRow(at: IndexPath.init(row: 0, section: 1)) as! TextFieldTableViewCell
        let user_money = cell1.textField.text!
        let pay_pass = cell2.textField.text!
        
        let request = TransferRequest(parameter: ["access_token": access_token, "mobile_phone": verificatedPhone, "user_money": user_money, "pay_pass": pay_pass])
        
        URLSessionClient().alamofireSend(request) { [weak self] (models, error) in
            if error == nil {
                MBProgressHUD.showErrorAdded(message: "转账成功", to: self?.view)
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: { 
                    _ = self?.navigationController?.popViewController(animated: true)
                })
                
            }else {
                MBProgressHUD.showErrorAdded(message: (error as! TransferError).info(), to: self?.view)
            }
        }
    }
    
}
