//
//  MineCollectionViewCell.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/3/1.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit

class MineCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
