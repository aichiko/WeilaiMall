//
//  RechargeViewController.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/3/15.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit
import MBProgressHUD

/// 充值 页面
class RechargeViewController: ViewController {

    var tableView = UITableView.init(frame: CGRect.zero, style: .grouped)
    let cellIdentifier = "RechargeCell"
    let button: CCSureButton = CCSureButton.init("确认充值")
    
    let titles: [String] = ["充值金额", "支付方式"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        configTableView()
        
        prepareData()
    }
    
    private func prepareData() {
        URLSessionClient().alamofireSend(UserBalanceRequest(parameter: ["access_token": access_token]),  handler: { [weak self] (models, error) in
            if error == nil {
                
            }else {
                MBProgressHUD.showErrorAdded(message: (error as! RequestError).info(), to: self?.view)
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
                let textField = UITextField.init()
                cell?.contentView.addSubview(textField)
                textField.keyboardType = .numberPad
                textField.font = UIFont.CCsetfont(16)
                textField.placeholder = "3000"
                textField.snp.updateConstraints({ (make) in
                    make.left.equalTo((cell?.textLabel?.snp.right)!).offset(10)
                    make.right.equalTo(-10)
                    make.height.equalToSuperview()
                })
                
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
