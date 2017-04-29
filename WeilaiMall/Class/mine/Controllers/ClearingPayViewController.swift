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
    
    var number: Int {
        didSet {
            payLabel.attributedText = attributeNumber(number: number*pay_attri.1)
        }
    }
    
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
    
    func attributeNumber(number: Int) -> NSMutableAttributedString {
        let dic1 = [NSFontAttributeName: UIFont.CCsetfont(14)!, NSForegroundColorAttributeName: UIColor(red:0.42, green:0.42, blue:0.42, alpha:1.00)]
        let dic2 = [NSFontAttributeName: UIFont.CCsetfont(14)!, NSForegroundColorAttributeName: UIColor(red:0.88, green:0.05, blue:0.00, alpha:1.00)]
        let text = String.init(format: "应付积分  %d", number)
        let attString = NSMutableAttributedString.init(string: text)
        attString.addAttributes(dic1, range: NSRange.init(location: 0, length: 5))
        attString.addAttributes(dic2, range: NSRange.init(location: 5, length: text.characters.count-5))
        return attString
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
        
        let dic1 = [NSFontAttributeName: UIFont.CCsetfont(14)!, NSForegroundColorAttributeName: UIColor(red:0.42, green:0.42, blue:0.42, alpha:1.00)]
        let dic2 = [NSFontAttributeName: UIFont.CCsetfont(14)!, NSForegroundColorAttributeName: UIColor(red:0.88, green:0.05, blue:0.00, alpha:1.00)]
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
    
    let nextButton: CCSureButton = CCSureButton.init("确定支付")
    let footView = UIView()
    let messageLabel = UILabel()
    let lineLabel: UILabel = {
        let lineLabel = UILabel()
        lineLabel.backgroundColor = UIColor.black
        return lineLabel
    }()
    let codeButton = CCSureButton.init("收款二维码")
    
    let celltexts = ["对方账号", "店铺名称", "现金结算额", "支付密码"]
    let placeholders = ["请输入对方手机号或店铺ID", "请输入店铺名称", "请输入现金价值", "请输入支付密码"]
    
    var balance: Float = 0
    var pay_ratio: Int = 2
    
    var codeMessage = ""
    
    typealias refreshData = () -> Void
    
    var refresh: refreshData?
    
    /// 是否验证 转账前需要先填写用户手机号，确认后才能进行后续的转账
    var isVerification = false
    
    /// 已经验证的手机号， 如果用户更改了验证的手机号，则需要重新验证
    var verificatedPhone: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let rightItem = UIBarButtonItem.init(image: UIImage.init(named: "scan_btn")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(scanCode(item:)))
        self.navigationItem.rightBarButtonItem = rightItem
        
        configTableView()
        
        prepareData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(textChange(not:)), name: .UITextFieldTextDidChange, object: nil)
    }

    @objc private func scanCode(item: UIBarButtonItem) {
        self.performSegue(withIdentifier: "clearing_code", sender: self)
    }
    
    @objc private func textChange(not: Notification) {
        let cell1 = tableView.cellForRow(at: IndexPath.init(row: 2, section: 0)) as! TextFieldTableViewCell
        let cell2 = tableView.cellForRow(at: IndexPath.init(row: 0, section: 1)) as! TextFieldTableViewCell
        
        if (cell1.textField.text?.characters.count)! > 0 && (cell2.textField.text?.characters.count)! > 0   {
            nextButton.buttonDisabled = true
        }else {
            nextButton.buttonDisabled = false
        }
        
        if let textField = not.object as? UITextField, textField.tag == 102 {
            //print(textField.text!)
            if textField.text == "" || textField.text == nil {
                let headview = tableView.headerView(forSection: 1) as! cellHeadView
                headview.number = 0
                return
            }
            let headview = tableView.headerView(forSection: 1) as! cellHeadView
            headview.number = Int(textField.text!)!
        }
        
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
                self?.footViewStatus(with: models[0]!.is_pay)
                self?.codeMessage = models[0]!.pay_phone
            }else {
                MBProgressHUD.showErrorAdded(message: (error?.getInfo())!, to: self?.view)
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
        
        footView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 200)
        footView.isUserInteractionEnabled = true
        tableView.tableFooterView = footView
        
        footView.addSubview(nextButton)
        nextButton.buttonDisabled = false
        nextButton.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.width.equalTo(self.view.bounds.width-40)
            make.height.equalTo(40)
            make.top.equalTo(30)
        }
        
        footView.addSubview(lineLabel)
        
        lineLabel.snp.updateConstraints { (make) in
            make.top.equalTo(nextButton.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(0.5)
        }
        messageLabel.text = "您的账户已开通收款权限，点击查看您的收款二维码"
        messageLabel.font = CCTextFont
        messageLabel.textColor = CCGrayTextColor
        messageLabel.textAlignment = .center
        messageLabel.adjustsFontSizeToFitWidth = true
        footView.addSubview(messageLabel)
        messageLabel.snp.updateConstraints { (make) in
            make.top.equalTo(lineLabel.snp.bottom).offset(10)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.centerX.equalToSuperview()
        }
        footView.addSubview(codeButton)
        codeButton.snp.updateConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(messageLabel.snp.bottom).offset(20)
            make.width.equalToSuperview().multipliedBy(0.45)
            make.height.equalTo(40)
        }
        codeButton.addTarget(self, action: #selector(payCodeAction(_:)), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(paymentAction(_:)), for: .touchUpInside)
        
        footViewStatus()
    }
    
    
    func footViewStatus(with is_pay: Bool = false) {
        if is_pay {
            footView.frame.size.height = 200
            lineLabel.isHidden = false
            messageLabel.isHidden = false
            codeButton.isHidden = false
        }else {
            footView.frame.size.height = 100
            lineLabel.isHidden = true
            messageLabel.isHidden = true
            codeButton.isHidden = true
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "clearing_code" {
            let controller = segue.destination as! ScanCodeViewController
            controller.isHome = false
            controller.codeMessage = {
                message in
                
                let strIndex = message.index(message.startIndex, offsetBy: 4)
                let phoneNum = message.substring(from: strIndex)
                self.decode(with: phoneNum)
            }
        }else if segue.identifier == "push_paycode" {
            let controller = segue.destination as! CCPayCodeViewController
            let code = sender as! String
            controller.code.append(code)
        }
        
    }
    
    /// 解密 手机号
    func decode(with phoneNum: String) {
        
        let request = AesdecryptRequest(parameter: ["encrypt_phone": phoneNum])
        URLSessionClient().alamofireSend(request) { [weak self] (phones, error) in
            if error == nil {
                let phoneNumber = phones[0]
                if let textFeild = self?.view.viewWithTag(100) as? UITextField {
                    textFeild.text = phoneNumber
                    self?.verificatePhone(phoneNum: phoneNumber!, textField: textFeild)
                }
            }else{
                MBProgressHUD.showErrorAdded(message: (error?.getInfo())!, to: self?.view)
            }
        }
        
    }
}

extension ClearingPayViewController: UITableViewDelegate, UITableViewDataSource {
    @available(iOS 2.0, *)
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let headview = cellHeadView.init(0)
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
            if indexPath.section == 0 && indexPath.row == 1 {
                cell?.textField.removeFromSuperview()
            }
            cell?.textField.delegate = self
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

extension ClearingPayViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 102, var text: String = textField.text {
            if string == "" {
                //remove
                //text.remove(at: text.endIndex)
            }else {
                text.append(string)
            }
            if text.characters.count > 8 {
                return false
            }
            if let num = Float(text), num*Float(pay_ratio) > balance {
                MBProgressHUD.showErrorAdded(message: String.init(format: "您最多可转账%.0f积分", balance), to: self.view)
                return false
            }
        }
        return true
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if !isVerification && textField.tag != 100 {
            MBProgressHUD.showErrorAdded(message: "请先验证手机号／店铺ID", to: self.view)
            textField.endEditing(true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.tag == 100 {
            // 点击完成后，验证手机号
            verificatePhone(phoneNum: textField.text!, textField: textField)
        }
        return true
    }
}


// MARK: - request
extension ClearingPayViewController {
    
    func verificatePhone(phoneNum: String, textField: UITextField) {
        if phoneNum == "" {
            return
        }
        let hud = MBProgressHUD.showMessage(message: "", view: self.view)
        let request = VerificationShopRequest(parameter: ["access_token": access_token, "mobile_phone": phoneNum])
        URLSessionClient().alamofireSend(request) { [weak self] (models, error) in
            hud.hide(animated: true)
            if error == nil {
                self?.isVerification = true
                self?.verificatedPhone = phoneNum
                let cell = self?.tableView.cellForRow(at: IndexPath.init(row: 1, section: 0)) as! TextFieldTableViewCell
                cell.real_name = (models[0]?.shop_name)!
                textField.isEnabled = false
            }else {
                MBProgressHUD.showErrorAdded(message: (error?.getInfo())!, to: self?.view)
            }
        }
    }
    
    
    @objc func paymentAction(_ button: UIButton) {
        let cell1 = tableView.cellForRow(at: IndexPath.init(row: 2, section: 0)) as! TextFieldTableViewCell
        let cell2 = tableView.cellForRow(at: IndexPath.init(row: 0, section: 1)) as! TextFieldTableViewCell
        let user_money = cell1.textField.text!
        let pay_pass = cell2.textField.text!
        
        let request = PaymentRequest(parameter: ["access_token": access_token, "mobile_phone": verificatedPhone, "user_money": user_money, "pay_pass": pay_pass])
        let hud = MBProgressHUD.showMessage(message: "", view: self.view)
        URLSessionClient().alamofireSend(request) { [weak self] (models, error) in
            hud.hide(animated: true)
            if error == nil {
                MBProgressHUD.showErrorAdded(message: "支付成功", to: self?.view)
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                    _ = self?.navigationController?.popViewController(animated: true)
                    if self?.refresh != nil {
                        self?.refresh!()
                    }
                })
                
            }else {
                MBProgressHUD.showErrorAdded(message: (error?.getInfo())!, to: self?.view)
            }
        }
    }
    
    @objc func payCodeAction(_ button: UIButton) {
        self.performSegue(withIdentifier: "push_paycode", sender: codeMessage)
    }
    
}

