//
//  CCShoppingCarHeadView.swift
//  24HMB
//
//  Created by 24hmb on 2017/3/2.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit

class CCShoppingCarHeadView: UITableViewHeaderFooterView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var whiteView = UIView()
    
    var button = UIButton.init(type: .custom)
    
    let titleLabel = UILabel()

    var buttonAction: CCButtonAction?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
//        self.title = title
        loadSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CCShoppingCarHeadView {
    fileprivate func loadSubviews() {
        contentView.addSubview(whiteView)
        whiteView.backgroundColor = UIColor.white
        
        whiteView.snp.updateConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(38)
        }
        
        whiteView.addSubview(button)
        whiteView.addSubview(titleLabel)
        
        button.snp.updateConstraints { (make) in
            make.left.equalToSuperview()
            make.centerY.height.equalTo(self.whiteView)
            make.width.equalTo(40)
        }
        button.setImage(UIImage.init(named: "cc_shopping_unselect"), for: .normal)
        button.setImage(UIImage.init(named: "cc_shopping_choice"), for: .selected)
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10)
        
        titleLabel.snp.updateConstraints { (make) in
            make.centerY.equalTo(self.whiteView)
            make.left.equalTo(self.button.snp.right).offset(0)
        }
        
        titleLabel.text = "全球肥胖会议主办方"
        titleLabel.textColor = UIColor.colorWithString("#555555")
        titleLabel.font = UIFont.CCsetfont(13)
        
        button.addTarget(self, action: #selector(headButtonAction(_:)), for: .touchUpInside)
    }
    
    /// 点击head button 选中
    ///
    /// - Parameters:
    ///   - button: button
    @objc private func headButtonAction(_ button: UIButton) {
        button.isSelected = !button.isSelected
        if buttonAction != nil {
            buttonAction!(button)
        }
    }
}
