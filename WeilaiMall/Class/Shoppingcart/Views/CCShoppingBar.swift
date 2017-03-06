//
//  CCShoppingBar.swift
//  24HMB
//
//  Created by 24hmb on 2017/3/2.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit


/// bar的不同风格
///
/// - nomal: 正常风格，结算价格
/// - editing: 编辑风格，删除商品
enum CCShoppingBarStyle {
    case normal
    case editing
}

/// 购物车 bar
class CCShoppingBar: UIToolbar {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
     layer.shadowOffset = CGSize(width: 0, height: 1)
     layer.shadowColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
     layer.shadowOpacity = 1.0
    }
    */
    
    var clearCount: Int = 0 {
        didSet {
            clearingButton.setTitle(String.init(format: "结算（%d）", clearCount), for: .normal)
        }
    }
    
    var price: Float = 0 {
        didSet {
            priceLabelAttributeText(price)
        }
    }
    
    var style: CCShoppingBarStyle = .normal {
        didSet {
            if style == .editing {
                totalpricesLabel.isHidden = true
                clearingButton.backgroundColor = UIColor.colorWithString("#FF3C26")
                selectButton.setTitleColor(UIColor.colorWithString("#FF3C26"), for: .selected)
                clearingButton.setTitle("删除", for: .normal)
                
            }else {
                totalpricesLabel.isHidden = false
                clearingButton.backgroundColor = CCOrangeColor
                selectButton.setTitleColor(CCOrangeColor, for: .selected)
                clearingButton.setTitle("结算", for: .normal)
            }
        }
    }
    
    /// 全选按钮
    var selectButton = UIButton.init(type: .custom)
    
    /// 总价label
    let totalpricesLabel = UILabel()
    
    /// 结算button
    let clearingButton = UIButton.init(type: .custom)
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
        layer.shadowOpacity = 1.0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialization()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension CCShoppingBar {
    fileprivate func initialization() {
        self.backgroundColor = UIColor.white
        self.addSubview(selectButton)
        self.addSubview(totalpricesLabel)
        self.addSubview(clearingButton)
        
        selectButton.snp.updateConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(70)
        }
        
        totalpricesLabel.snp.updateConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(self.selectButton.snp.right).offset(25)
        }
        
        clearingButton.snp.updateConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(self.totalpricesLabel.snp.right).offset(20)
            make.right.top.equalToSuperview()
            make.height.equalToSuperview()
            make.width.lessThanOrEqualTo(150)
        }
        
        subviewAttribute()
    }
    
    private func subviewAttribute() {
        selectButton.setImage(UIImage.init(named: "cc_shopping_unselect"), for: .normal)
        selectButton.setImage(UIImage.init(named: "cc_shopping_choice"), for: .selected)
        selectButton.setTitle("全选", for: .normal)
        selectButton.setTitleColor(CCTitleTextColor, for: .normal)
        selectButton.setTitleColor(CCOrangeColor, for: .selected)
        selectButton.titleLabel?.font = CCTextFont
        selectButton.titleEdgeInsets.left = 10
        
        priceLabelAttributeText(price)
        
        clearingButton.backgroundColor = CCOrangeColor
        clearingButton.setTitle("结算", for: .normal)
        clearingButton.setTitleColor(UIColor.white, for: .normal)
        clearingButton.setTitleColor(UIColor.lightGray, for: .highlighted)
        clearingButton.titleLabel?.font = UIFont.CCsetfont(16, "PingFang-SC-Medium")
    }
}

extension CCShoppingBar {
    fileprivate func priceLabelAttributeText(_ newPrice: Float) {
        
        let attributeText = NSMutableAttributedString.init(string: String.init(format: "合计：¥ %.2f", price))
        let dic1 = [NSFontAttributeName: UIFont.CCsetfont(12), NSForegroundColorAttributeName: CCTitleTextColor]
        attributeText.addAttributes(dic1, range: NSRange.init(location: 0, length: 3))
        let dic2 = [NSFontAttributeName: UIFont.CCsetfont(12), NSForegroundColorAttributeName: CCOrangeColor]
        attributeText.addAttributes(dic2, range: NSRange.init(location: 3, length: 1))
        let dic3 = [NSFontAttributeName: UIFont.CCsetfont(16), NSForegroundColorAttributeName: CCOrangeColor]
        attributeText.addAttributes(dic3, range: NSRange.init(location: 4, length: attributeText.length-4))
        
        totalpricesLabel.attributedText = attributeText
    }
}


