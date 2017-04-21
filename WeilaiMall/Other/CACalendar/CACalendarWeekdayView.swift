//
//  CACalendarWeekdayView.swift
//  Calendar_demo
//
//  Created by 24hmb on 2017/2/17.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit

class CACalendarWeekdayView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    let weekdays: [String] = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //initialization()
        self.backgroundColor = UIColor.white
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //initialization()
        //fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        initialization()
    }
}

extension CACalendarWeekdayView {
    public func initialization() {
        for i in 0..<7 {
            let label = UILabel()
            self.addSubview(label)
            label.text = weekdays[i]
            label.textColor = UIColor.blue
            label.textAlignment = .center
            label.snp.makeConstraints({ (make) in
                make.centerY.equalToSuperview()
                make.width.equalToSuperview().multipliedBy(Float(1.0/7.0))
                make.left.equalTo(CGFloat(i)*self.bounds.width/7)
                make.height.equalToSuperview()
            })
        }
    }
}
