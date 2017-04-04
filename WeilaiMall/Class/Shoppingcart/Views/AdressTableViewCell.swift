//
//  AdressTableViewCell.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/4/3.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit


class AdressFootView: UITableViewHeaderFooterView {
    
    let selectButton = UIButton(type: .custom)
    
    let editButton = UIButton(type: .system)
    
    let deleteButton = UIButton(type: .system)
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        loadSubviews()
        
    }
    
    
    func loadSubviews() {
        contentView.addSubview(selectButton)
        
        selectButton.titleEdgeInsets.left = 10
        selectButton.setTitle("默认地址", for: .normal)
        selectButton.setTitleColor(UIColor.black, for: .normal)
        selectButton.setTitleColor(CCOrangeColor, for: .selected)
        selectButton.setImage(UIImage.init(named: "cc_shopping_unselect"), for: .normal)
        selectButton.setImage(UIImage.init(named: "cc_shopping_choice"), for: .selected)
        selectButton.titleLabel?.font = CCTextFont
        
        
        selectButton.snp.updateConstraints { (make) in
            make.left.equalTo(10)
            make.centerY.equalToSuperview()
        }
        
        editButton.setImage(UIImage.init(named: "ca-address-icon"), for: .normal)
        editButton.setTitle("编辑", for: .normal)
        editButton.titleLabel?.font = CCTextFont
        
        
        deleteButton.setImage(UIImage.init(named: "ca-del-icon"), for: .normal)
        deleteButton.setTitle("删除", for: .normal)
        deleteButton.titleLabel?.font = CCTextFont
        
        contentView.addSubview(editButton)
        contentView.addSubview(deleteButton)
        
        editButton.snp.updateConstraints { (make) in
            make.right.equalTo(self.deleteButton.snp.left).offset(-10)
            make.width.equalTo(60)
            make.centerY.equalToSuperview()
        }
        
        deleteButton.snp.updateConstraints { (make) in
            make.right.equalTo(-15)
            make.width.equalTo(60)
            make.centerY.equalToSuperview()
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class AdressTableViewCell: UITableViewCell {
    
    enum AdressStyle {
        case noAdress
        case defaultAdress
    }
    
    let style: AdressStyle
    
    lazy var nameLabel = UILabel()
    
    lazy var adressLabel = UILabel()
    
    lazy var phoneLabel = UILabel()
    
    var adress: ShoppingCartAdress? {
        didSet {
            guard adress != nil else {
                return
            }
            
            nameLabel.text = "收货人：" + adress!.consignee
            adressLabel.text = "收货地址：" + adress!.address
            phoneLabel.text = String(adress!.mobile)
        }
    }
    
    init(style: AdressStyle = .noAdress, reuseIdentifier: String?) {
        self.style = style
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        if style == .noAdress {
            noAdressSubviews()
        }else {
            adressViews()
        }
    }
    
    private func noAdressSubviews() {
        let button = UIButton.init(type: .custom)
        
        button.setImage(UIImage.init(named: "cc_shopping_add"), for: .normal)
        button.setTitle("请添加收货地址", for: .normal)
        button.setTitleColor(CCOrangeColor, for: .normal)
        button.titleLabel?.font = UIFont.CCsetfont(16)
        contentView.addSubview(button)
        
        button.titleEdgeInsets.left = 15
        
        button.snp.updateConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
        }
    }
    
    private func adressViews() {
        accessoryType = .disclosureIndicator
        contentView.addSubview(nameLabel)
        contentView.addSubview(adressLabel)
        contentView.addSubview(phoneLabel)
        
        nameLabel.font = CCTextFont
        adressLabel.font = CCTextFont
        phoneLabel.font = CCTextFont
        
        nameLabel.snp.updateConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(15)
        }
        
        adressLabel.snp.updateConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(self.nameLabel.snp.bottom).offset(10)
        }
        
        phoneLabel.snp.updateConstraints { (make) in
            make.right.equalTo(-15)
            make.centerY.equalTo(self.nameLabel)
        }
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
