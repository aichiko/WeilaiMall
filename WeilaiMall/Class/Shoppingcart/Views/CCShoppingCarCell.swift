//
//  CCShoppingCarCell.swift
//  24HMB
//
//  Created by 24hmb on 2017/3/2.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit

/// 购物车 cell
class CCShoppingCarCell: UITableViewCell {
    
    @IBOutlet weak var selectButton: UIButton!
    
    @IBOutlet weak var meetImageView: UIImageView!
    
    @IBOutlet weak var meetTitleLabel: UILabel!
    
    @IBOutlet weak var packageLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var numberView: CCShoppingNumberView!
    
    var changeText: ((_ newText: String) -> Void)?
    
    var buttonAction: CCButtonAction?
    
    var textFieldText: String? = "1" {
        didSet {
            numberView.numberTextField.text = textFieldText
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        packageLabel.isHidden = true
        
        numberView.changeText = {
            [unowned self] text in
            if self.changeText != nil {
                self.changeText!(text)
            }
        }
        selectButton.addTarget(self, action: #selector(cellButtonAction(_:)), for: .touchUpInside)
        
    }
    
    /// 点击cell button 选中
    ///
    /// - Parameters:
    ///   - button: button
    @objc func cellButtonAction(_ button: UIButton) {
        button.isSelected = !button.isSelected
        if buttonAction != nil {
            buttonAction!(button)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
