//
//  MineHeadView.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/3/1.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit

class MineHeadView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.orange
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
