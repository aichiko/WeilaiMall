//
//  OrderTableViewCell.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/3/10.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit
import Kingfisher

class OrderTableViewCell: UITableViewCell {

    
    @IBOutlet weak var goodImageView: UIImageView!
    
    @IBOutlet weak var goodnameLabel: UILabel!
    
    @IBOutlet weak var goodpriceLabel: UILabel!
    
    @IBOutlet weak var goodnumberLabel: UILabel!
    
    var model: OrderGoodsModel? {
        didSet {
            guard model != nil else {
                return
            }
            goodImageView.kf.setImage(with: URL(string: (model?.goods_img)!), placeholder: UIImage.init(named: ""))
            goodnameLabel.text = model?.goods_name
            goodpriceLabel.text = String.init(format: "%.0f", (model?.goods_price)!)
            goodnumberLabel.text = String.init(format: "x%d", (model?.goods_num)!)
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
