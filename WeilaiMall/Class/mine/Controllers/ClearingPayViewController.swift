//
//  ClearingPayViewController.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/3/12.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit
import MBProgressHUD

fileprivate class cellHeadView: UITableViewHeaderFooterView {
    
    var multipleLabel = UILabel()
    
    var payLabel = UILabel()
    
    var balanceLabel = UILabel()
    
    let number: Int
    
    var pay_attri: (Float, Int) {
        didSet {
            multipleLabel.text = "支付倍数  当前系统\(pay_attri.1)倍结算"
            balanceLabel.text =  String.init(format: "当前余额%.0f积分", pay_attri.0)
        }
    }
    
    init(_ payNumber: Int) {
        number = payNumber
        pay_attri = (8000.0, 2)
        super.init(reuseIdentifier: "")
        
        configSubviews()
    }
    
    private func configSubviews() {
        
        addSubview(multipleLabel)
        addSubview(payLabel)
        addSubview(balanceLabel)
        
        multipleLabel.font = UIFont.CCsetfont(14)
        payLabel.font = UIFont.CCsetfont(14)
        balanceLabel.font = UIFont.CCsetfont(14)
        multipleLabel.textColor = UIColor(red:0.42, green:0.42, blue:0.42, alpha:1.00)
        balanceLabel.textColor = UIColor(red:0.88, green:0.05, blue:0.00, alpha:1.00)
        
        multipleLabel.text = "支付倍数  当前系统2倍结算"
        balanceLabel.text = "当前余额8000积分"
        
        let dic1 = [NSFontAttributeName: UIFont.CCsetfont(14), NSForegroundColorAttributeName: UIColor(red:0.42, green:0.42, blue:0.42, alpha:1.00)]
        let dic2 = [NSFontAttributeName: UIFont.CCsetfont(14), NSForegroundColorAttributeName: UIColor(red:0.88, green:0.05, blue:0.00, alpha:1.00)]
        let text = String.init(format: "应付积分  %d", self.number)
        let attString = NSMutableAttributedString.init(string: text)
        attString.addAttributes(dic1, range: NSRange.init(location: 0, length: 5))
        attString.addAttributes(dic2, range: NSRange.init(location: 5, length: text.characters.count-5))
        payLabel.attributedText = attString
        
        
        multipleLabel.snp.updateConstraints { (make) in
            make.top.left.equalTo(15)
        }
        
        payLabel.snp.updateConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(self.multipleLabel.snp.bottom).offset(5)
        }
        
        balanceLabel.snp.updateConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(self.payLabel.snp.bottom).offset(10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// 结算支付 页面
class ClearingPayViewController: ViewController {

    let cellIdentifier = "TransferCell"
    
    var tableView = UITableView(frame: CGRect.zero, style: .grouped)
    
    let nextButton: CCSureButton = CCSureButton.init("下一步")
    
    let celltexts = ["对方账号", "店铺名称", "现金结算额", "支付密码"]
    let placeholders = ["请输入对方手机号或店铺ID", "请输入店铺名称", "请输入现金价值", "请输入支付密码"]
    
    var balance: Float = 0
    var pay_ratio: Int = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        configTableView()
        
        prepareData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func prepareData() {
        URLSessionClient().alamofireSend(UserBalanceRequest(parameter: ["access_token": access_token]),  handler: { [weak self] (models, error) in
            if error == nil {
                self?.balance = models[0]!.user_money
                self?.pay_ratio = models[0]!.pay_ratio
                self?.tableView.reloadSections(IndexSet.init(integer: 1), with: .automatic)
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
        
        tableView.addSubview(nextButton)
        nextButton.buttonDisabled = false
        nextButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(40)
            make.top.equalTo(330)
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

extension ClearingPayViewController: UITableViewDelegate, UITableViewDataSource {
    @available(iOS 2.0, *)
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let headview = cellHeadView.init(2000)
            headview.pay_attri = (balance, pay_ratio)
            return headview
        }else {
            let view = UITableViewHeaderFooterView.init()
            return view
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ?15: 110
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
            cell?.selectionStyle = .none
            cell?.textField.tag = 100+getIndex()
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

