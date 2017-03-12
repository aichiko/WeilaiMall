//
//  OperationRecordCell.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/3/12.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit

class OperationRecordCell: UITableViewCell {

    /// 账户
    @IBOutlet weak var accountLabel: UILabel!
    
    /// 积分
    @IBOutlet weak var integralLabel: UILabel!
    
    /// 收入支出
    @IBOutlet weak var incomingsLabel: UILabel!
    
    /// 带返积分
    @IBOutlet weak var backintergralLabel: UILabel!
    
    /// 累计消费
    @IBOutlet weak var cumulativeLabel: UILabel!
    
    /// 推广额度
    @IBOutlet weak var amountLabel: UILabel!
    
    /// 推广赠送
    @IBOutlet weak var amountGiveLabel: UILabel!
    
    var incomings: Float = 0 {
        didSet {
            incomingsLabel.textColor =  (incomings >= 0) ?UIColor.colorWithString("009900") :UIColor.colorWithString("cc3300")
            let str = (incomings >= 0) ?"+":""
            incomingsLabel.text = str+String.init(format: "%.2f", str, incomings)
        }
    }
    
    var backintergral: Float = 0 {
        didSet {
            backintergralLabel.textColor =  (backintergral >= 0) ?UIColor.colorWithString("009900") :UIColor.colorWithString("cc3300")
            let str = (backintergral >= 0) ?"+":""
            backintergralLabel.text = str+String.init(format: "%.0f", str, backintergral)
        }
    }
    
    var cumulative: Float = 0 {
        didSet {
            cumulativeLabel.textColor =  (cumulative >= 0) ?UIColor.colorWithString("009900") :UIColor.colorWithString("cc3300")
            let str = (cumulative >= 0) ?"+":""
            cumulativeLabel.text = str+String.init(format: "%.2f", str, cumulative)
        }
    }
    
    var amount: Float = 0 {
        didSet {
            amountLabel.textColor =  (amount >= 0) ?UIColor.colorWithString("009900") :UIColor.colorWithString("cc3300")
            let str = (amount >= 0) ?"+":""
            amountLabel.text = str+String.init(format: "%.0f", str, amount)
        }
    }
    
    var amountGive: Float = 0 {
        didSet {
            amountGiveLabel.textColor =  (amountGive >= 0) ?UIColor.colorWithString("009900") :UIColor.colorWithString("cc3300")
            
            let str = (amountGive >= 0) ?"+":""
            amountGiveLabel.text = str+String.init(format: "%.0f", str, amountGive)
        }
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
