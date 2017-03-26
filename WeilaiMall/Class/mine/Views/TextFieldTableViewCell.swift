//
//  TextFieldTableViewCell.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/3/12.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit

class TextFieldTableViewCell: UITableViewCell {

    var textField = UITextField()
    
    var titleLabel: UILabel = UILabel()
    
    let cellText: (String, String)
    
    let realnameLabel = UILabel()
    
    var real_name = "" {
        didSet {
            realnameLabel.isHidden = false
            realnameLabel.text = real_name
        }
    }
    
    
    var keyboradType = UIKeyboardType.default {
        didSet {
            textField.keyboardType = keyboradType
            if keyboradType == .numberPad {
                addInputView(textField: textField)
            }
        }
    }
    
    init(cellText: (String, String), reuseIdentifier: String?) {
        self.cellText = cellText
        super.init(style: UITableViewCellStyle.default, reuseIdentifier: reuseIdentifier)
        loadSubviews()
    }
    
    private func loadSubviews() {
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(textField)
        
        titleLabel.text = cellText.0
        textField.placeholder = cellText.1
        
        titleLabel.font = CCTextFont
        titleLabel.textAlignment = .right
        titleLabel.adjustsFontSizeToFitWidth = true
        textField.keyboardType = keyboradType
        textField.font = CCTextFont
        
        
        titleLabel.snp.updateConstraints { (make) in
            make.left.lessThanOrEqualTo(15)
            make.centerY.top.height.equalToSuperview()
            make.width.equalTo(70)
        }
        
        textField.snp.updateConstraints { (make) in
            make.left.equalTo(self.titleLabel.snp.right).offset(15)
            make.centerY.top.height.equalToSuperview()
            make.right.equalTo(-15)
        }
        
        
        realnameLabel.text = real_name
        realnameLabel.font = CCTextFont
        //realnameLabel.textColor = CCGrayTextColor
        contentView.addSubview(realnameLabel)
        realnameLabel.snp.updateConstraints { (make) in
            make.left.equalTo(self.titleLabel.snp.right).offset(15)
            make.centerY.top.height.equalToSuperview()
            make.right.equalTo(-15)
        }
        realnameLabel.isHidden = true
        
    }
    
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
    
    @objc fileprivate func hideKeyborad() {
        textField.endEditing(true)
        if let delegate = textField.delegate, delegate.responds(to: #selector(UITextFieldDelegate.textFieldShouldReturn(_:))) {
            _ = delegate.textFieldShouldReturn!(textField)
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
