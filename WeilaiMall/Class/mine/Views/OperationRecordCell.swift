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
    
    /// 收入支出
    var user_money: String = "" {
        didSet {
            guard let number = Float(user_money) else {
                return
            }
            incomingsLabel.textColor =  (number >= 0) ?UIColor.colorWithString("009900") :UIColor.colorWithString("cc3300")
            let str = (number > 0) ?"+":""
            incomingsLabel.text = str+user_money
        }
    }
    /// 带返积分
    var rebate: String = "" {
        didSet {
            guard let number = Float(rebate) else {
                return
            }
            backintergralLabel.textColor =  (number >= 0) ?UIColor.colorWithString("009900") :UIColor.colorWithString("cc3300")
            let str = (number >= 0) ?"+":""
            backintergralLabel.text = str+rebate
        }
    }
    /// 累计消费
    var pay_points: String = "" {
        didSet {
            guard let number = Float(pay_points) else {
                return
            }
            cumulativeLabel.textColor =  (number >= 0) ?UIColor.colorWithString("009900") :UIColor.colorWithString("cc3300")
            let str = (number >= 0) ?"+":""
            cumulativeLabel.text = str+pay_points
        }
    }
    /// 推广额度
    var highreward: String = "" {
        didSet {
            guard let number = Float(highreward) else {
                return
            }
            amountLabel.textColor =  (number >= 0) ?UIColor.colorWithString("009900") :UIColor.colorWithString("cc3300")
            let str = (number >= 0) ?"+":""
            amountLabel.text = str+highreward
        }
    }
    /// 推广赠送
    var payin: String = "" {
        didSet {
            guard let number = Float(payin) else {
                return
            }
            amountGiveLabel.textColor =  (number >= 0) ?UIColor.colorWithString("009900") :UIColor.colorWithString("cc3300")
            
            let str = (number >= 0) ?"+":""
            
            amountGiveLabel.text = str+payin
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
