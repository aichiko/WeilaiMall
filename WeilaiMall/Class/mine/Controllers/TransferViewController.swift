//
//  TransferViewController.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/3/12.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit

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
    
    let nextButton: CCSureButton = CCSureButton.init("下一步")
    
    let celltexts = ["对方账号", "真实姓名", "转账积分", "支付密码"]
    let placeholders = ["请输入对方手机号", "请输入真实姓名", "请输入转账积分", "请输入支付密码"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configTableView()
        addBackItem()
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
            cell?.selectionStyle = .none
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
