//
//  MineHeadView.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/3/1.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit

/// 积分 view
class IntegralView: UIView {
    
    let classLabel = UILabel()
    let integralLabel = UILabel()
    
    var type: Int = 0 {
        didSet {
            
        }
    }
    
    var integral: Float = 0.0 {
        didSet {
            integralAttribute()
        }
    }
    
    
    init(_ title: String) {
        super.init(frame: CGRect.zero)
        type = self.tag-100
        loadSubviews(title)
    }
    
    private func loadSubviews(_ title: String) {
        addSubview(classLabel)
        addSubview(integralLabel)
        
        classLabel.snp.updateConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(20)
        }
        integralLabel.snp.updateConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-20)
        }
        
        classLabel.textAlignment = .center
        integralLabel.textAlignment = .center
        classLabel.font = UIFont.CCsetfont(13)
        
        classLabel.text = title
        
        integralAttribute()
    }
    
    func integralAttribute() {
        if type == 0 {
            integralLabel.textColor = UIColor(red:0.99, green:0.23, blue:0.12, alpha:1.00)
            integralLabel.text = String(format: "%.0f", integral)
            integralLabel.font = UIFont.CCsetfont(13)
        }else if type == -1 {
            integralLabel.textColor = UIColor.black
            integralLabel.text = "0"
            //integralLabel.text = String(format: "%.0f", integral)
            integralLabel.font = UIFont.CCsetfont(13)
            
        }else {
            let string = String(format: "%.2f", integral)
            let attributeText = NSMutableAttributedString.init(string: string)
            let dic1 = [NSFontAttributeName: UIFont.CCsetfont(13), NSForegroundColorAttributeName: UIColor(red:0.99, green:0.23, blue:0.12, alpha:1.00)]
            let dic2 = [NSFontAttributeName: UIFont.CCsetfont(11), NSForegroundColorAttributeName: UIColor(red:0.99, green:0.23, blue:0.12, alpha:1.00)]
            
            attributeText.addAttributes(dic1, range: NSRange.init(location: 0, length: string.characters.count-2))
            attributeText.addAttributes(dic2, range: NSRange.init(location: string.characters.count-2, length: 2))
            
            integralLabel.attributedText = attributeText
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MineMessageButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadSubviews()
    }
    
    private func loadSubviews(){
        self.setTitle("个人信息", for: .normal)
        self.setTitleColor(UIColor.white, for: .normal)
        self.setTitleColor(UIColor.lightGray, for: .highlighted)
        self.titleLabel?.font = UIFont.CCsetfont(14)
        self.setImage(UIImage.init(named: "info_arrow"), for: .normal)
        
        self.imageEdgeInsets.right = -150
        self.titleEdgeInsets.left = -10
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


enum LoginStyle {
    case notlogin
    case logged
}

class MineHeadView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var style: LoginStyle = .notlogin {
        didSet {
            headShow(with: style)
            reloadViewAttribute()
        }
    }
    
    var userModel: UserModel! {
        didSet {
            nameLabel.text = userModel.user_name
            moneyLabel.text = String.init(format: "余额：%.2f", (userModel?.user_money)!)
            var integrals = [userModel.rebate, userModel.pay_points, userModel.highreward, userModel.payin]
            for i in 100..<104 {
                let view = self.viewWithTag(i) as! IntegralView
                if style == .notlogin {
                    view.type = -1
                }else {
                    view.type = i - 100
                }
                view.integral = integrals[i-100]
                view.integralAttribute()
            }
        }
    }
    
    let titleArray = ["待返积分", "总消费额", "推广额度", "推广赠送"]
    
    let headView = UIView()
    
    let imageView = UIImageView()
    
    let nameLabel = UILabel()
    
    let moneyLabel = UILabel()
    
    let loginButton = UIButton(type: .custom)
    
    let detailButton = MineMessageButton(type: .custom)
    
    var click: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        
        loadHeadsubviews()
        
        loadIntegralView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MineHeadView {
    func loadHeadsubviews() {
        headView.backgroundColor = UIColor.orange
        addSubview(headView)
        headView.snp.updateConstraints { (make) in
            make.left.right.top.equalTo(0)
            make.height.equalTo(145)
        }
        
        headView.addSubview(imageView)
        headView.addSubview(nameLabel)
        headView.addSubview(moneyLabel)
        
        imageView.snp.updateConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(25)
            make.width.height.equalTo(66)
        }
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 33
        imageView.image = UIImage.init(named: "login")
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(tapAction(_:))))
        
        headView.addSubview(loginButton)
        headView.addSubview(detailButton)
        loginButton.setTitle("登录/注册", for: .normal)
        loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.setTitleColor(UIColor.lightGray, for: .highlighted)
        loginButton.titleLabel?.font = UIFont.CCsetfont(15)
        loginButton.snp.updateConstraints { (make) in
            make.left.equalTo(self.imageView.snp.right).offset(20)
            make.centerY.equalToSuperview()
        }
        loginButton.addTarget(self, action: #selector(clickAction(_:)), for: .touchUpInside)
        
        detailButton.snp.updateConstraints { (make) in
            make.right.equalTo(-10)
            make.width.equalTo(100)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        detailButton.addTarget(self, action: #selector(clickAction(_:)), for: .touchUpInside)
        
        labelAttribute()
        headShow(with: style)
    }
    
    @objc private func clickAction(_ button: UIButton) {
        if click != nil {
            click!()
        }
    }
    
    @objc private func tapAction(_ tap: UITapGestureRecognizer) {
        if click != nil {
            click!()
        }
    }
    
    private func labelAttribute() {
        nameLabel.textColor = UIColor.white
        moneyLabel.textColor = UIColor.white
        nameLabel.font = UIFont.CCsetfont(14)
        moneyLabel.font = UIFont.CCsetfont(14)
        
        nameLabel.text = "ash"
        moneyLabel.text = String.init(format: "余额：%.2f", 222.2)
        
        nameLabel.snp.updateConstraints { (make) in
            make.left.equalTo(self.imageView.snp.right).offset(20)
            make.top.equalTo(50)
        }
        
        moneyLabel.snp.updateConstraints { (make) in
            make.left.equalTo(self.nameLabel)
            make.top.equalTo(self.nameLabel.snp.bottom).offset(20)
        }
    }
    
    func headShow(with style: LoginStyle) {
        loginButton.isHidden = style == .logged
        detailButton.isHidden = style == .notlogin
        nameLabel.isHidden = style == .notlogin
        moneyLabel.isHidden = style == .notlogin
    }
}

extension MineHeadView {
    func loadIntegralView() {
        for title in titleArray {
            let i = titleArray.index(of: title)
            let view = IntegralView.init(title)
            view.tag = 100+i!
            if style == .notlogin {
                view.type = -1
            }
            self.addSubview(view)
            view.integral = 100
            view.snp.updateConstraints({ (make) in
                make.top.equalTo(self.headView.snp.bottom)
                make.width.equalToSuperview().multipliedBy(0.25)
                make.height.equalTo(85)
                make.left.equalTo(CGFloat(i!)*UIScreen.main.bounds.width/4.0)
            })
        }
    }
    
    func reloadViewAttribute() {
        for i in 100..<104 {
            let view = self.viewWithTag(i) as! IntegralView
            if style == .notlogin {
                view.type = -1
            }else {
                view.type = i - 100
            }
            view.integralAttribute()
        }
    }
}
