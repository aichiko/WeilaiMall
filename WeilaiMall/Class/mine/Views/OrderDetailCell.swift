//
//  OrderDetailCell.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/3/16.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit

class OrderDetailCell: UITableViewCell {

    /// cell 显示风格
    ///
    /// - address: 地址
    /// - logistics: 物流
    enum DetailCellStyle {
        case address
        case logistics
    }
    
    let headWidth: Float = {
        let dic = [NSFontAttributeName: UIFont.CCsetfont(14)!]
        let str: NSString = "收货信息："
        let width = str.boundingRect(with: CGSize(width: 0, height: 0), options: .usesLineFragmentOrigin, attributes: dic, context: nil).width
        return Float(width)
    }()
    
    var style: DetailCellStyle {
        didSet {
            detailLabel.textColor = style == .address ?CCGrayTextColor:UIColor.black
        }
    }
    
    var model: OrderDetailModel? {
        didSet {
            if  model == nil {
                return
            }
            let styleHead = style == .address ?"收货信息：":"物流方式："
            if style == .address {
                styleLabel.text = styleHead + "\((model?.user_name)!) \((model?.mobile_phone)!)"
            }else {
                styleLabel.text = styleHead + (model?.shipping_name)!
            }
            detailLabel.text = style == .address ?model?.address:"物流单号：\((model?.invoice_no)!)"
        }
    }
    
    let styleLabel = UILabel()
    let detailLabel = UILabel()
    
    init(style: DetailCellStyle, reuseIdentifier: String) {
        self.style = style
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        configSubviews()
    }
    
    private func configSubviews() {
        contentView.addSubview(styleLabel)
        contentView.addSubview(detailLabel)
        
        styleLabel.snp.updateConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(10)
        }
        
        detailLabel.snp.updateConstraints { (make) in
            make.left.equalTo(self.styleLabel.snp.left).offset(style == .address ?headWidth:0)
            make.top.equalTo(self.styleLabel.snp.bottom).offset(10)
            make.right.lessThanOrEqualTo(0)
        }
        
        styleLabel.font = UIFont.CCsetfont(14)
        detailLabel.font = UIFont.CCsetfont(14)
        
        detailLabel.textColor = style == .address ?CCGrayTextColor:UIColor.black
        
        let styleHead = style == .address ?"收货信息：":"物流方式："
        
        styleLabel.text = styleHead + "茅十八 18888888888"
        
        detailLabel.text = style == .address ?"浙江省嘉兴市未来大道未来加商城1号":"物流单号：1888888888"
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
