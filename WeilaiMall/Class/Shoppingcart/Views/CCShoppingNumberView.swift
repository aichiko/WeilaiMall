//
//  CCShoppingNumberView.swift
//  24HMB
//
//  Created by 24hmb on 2017/3/2.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit

class CCShoppingNumberView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var minusButton = UIButton(type: .custom)
    
    var addButton = UIButton(type: .custom)
    
    var numberTextField = UITextField()
    
    var changeText: ((_ newText: String) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        loadSubViews()
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        let upLine = CALayer.init()
        let downLine = CALayer.init()
        let width = numberTextField.bounds.width
        let pointY = numberTextField.bounds.height - CGFloat(0.5)
        upLine.frame = CGRect(x: 0, y: 0, width: width, height: 0.5)
        downLine.frame = CGRect(x: 0, y: pointY, width: width, height: 0.5)
        
        downLine.backgroundColor = UIColor.colorWithString("#CACACB").cgColor
        upLine.backgroundColor = UIColor.colorWithString("#CACACB").cgColor
        numberTextField.layer.addSublayer(downLine)
        numberTextField.layer.addSublayer(upLine)
        
        addButton.layer.borderColor = UIColor.colorWithString("#CACACB").cgColor
        addButton.layer.borderWidth = 0.5
        
        minusButton.layer.borderColor = UIColor.colorWithString("#CACACB").cgColor
        minusButton.layer.borderWidth = 0.5
    }
}

extension CCShoppingNumberView {
    fileprivate func loadSubViews() {
        self.backgroundColor = UIColor.white
        self.addSubview(minusButton)
        self.addSubview(addButton)
        self.addSubview(numberTextField)
        
        minusButton.tag = 101
        addButton.tag = 102
        
        addButton.setImage(UIImage.init(named: "cc_shopping_add"), for: .normal)
        minusButton.setImage(UIImage.init(named: "cc_shopping_reduce"), for: .normal)
        addButton.addTarget(self, action: #selector(changeNumber(_:)), for: .touchUpInside)
        minusButton.addTarget(self, action: #selector(changeNumber(_:)), for: .touchUpInside)
        
        numberTextField.font = UIFont.CCsetfont(14)
        numberTextField.textColor = CCTitleTextColor
        numberTextField.text = "1"
        numberTextField.textAlignment = .center
        numberTextField.delegate = self
        numberTextField.keyboardType = .numberPad
        
        addInputView()

        addButton.snp.updateConstraints { (make) in
            make.centerY.right.height.equalToSuperview()
            make.width.equalTo(25)
        }
        numberTextField.snp.updateConstraints { (make) in
            make.centerY.height.equalToSuperview()
            make.right.equalTo(self.addButton.snp.left).offset(0)
            make.width.equalTo(35)
        }
        minusButton.snp.updateConstraints { (make) in
            make.centerY.height.equalToSuperview()
            make.right.equalTo(self.numberTextField.snp.left).offset(0)
            make.width.equalTo(25)
        }
    }
    
    @objc private func changeNumber(_ button: UIButton) {
        
        var result = Int(numberTextField.text!)
        if button.tag == 101 {
            //减少数量
            if result == 1 {
                return
            }else {
                result! -= 1
            }
        }else if button.tag == 102 {
            //增加数量
            result! += 1
        }
        numberTextField.text = result?.description
        if self.changeText != nil {
            self.changeText!(numberTextField.text!)
        }
    }

}

extension CCShoppingNumberView {
    /// 增加 inputAccessoryView 方便键盘的回收
    func addInputView() {
        let accessoryView = UIView()
        accessoryView.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.00)
        accessoryView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40)
        numberTextField.inputAccessoryView = accessoryView
        
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
    
    @objc private func hideKeyborad() {
        numberTextField.endEditing(true)
    }
}

extension CCShoppingNumberView: UITextFieldDelegate {
    // MARK: UITextFieldDelegate
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" {
            print("输入的数字无效")
            //重新赋值
            textField.text = "1"
        }
        if let result = Int(textField.text!), result < 1 {
            print("输入的数字无效")
            //重新赋值
            textField.text = "1"
        }
        if self.changeText != nil {
            self.changeText!(textField.text!)
        }
    }
}

