//
//  CCTabBar.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/2/26.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit

extension CCTabBar {
    fileprivate func itemAttribute(_ title: String, image: String, selectedImage: String) {
        
    }
}
    

class CCTabBar: UITabBar {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var tabbarButtons: [Any] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        print(self.subviews)
        
        for item in self.subviews {
            if item.isKind(of: NSClassFromString("UITabBarButton")!) {
                tabbarButtons.append(item)
            }
        }
        
        
    }
}
