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
    
    var keyboradType = UIKeyboardType.default {
        didSet {
            textField.keyboardType = keyboradType
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
        textField.font = CCTextFont
        textField.keyboardType = keyboradType
        
        titleLabel.snp.updateConstraints { (make) in
            make.left.lessThanOrEqualTo(15)
            make.centerY.top.height.equalToSuperview()
            make.width.lessThanOrEqualTo(70)
        }
        
        textField.snp.updateConstraints { (make) in
            make.left.equalTo(self.titleLabel.snp.right).offset(15)
            make.centerY.top.height.equalToSuperview()
            make.right.equalTo(-15)
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
