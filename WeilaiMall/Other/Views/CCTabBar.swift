//
//  CCTabBar.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/2/26.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit

extension UITabBarItem {
    fileprivate func itemAttribute(_ title: String, image: String, selectedImage: String) {
        self.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.colorWithString("f55633")], for: .selected)
        self.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.colorWithString("333333")], for: .normal)
        self.image = UIImage.init(named: image)?.withRenderingMode(.alwaysOriginal)
        self.selectedImage = UIImage.init(named: selectedImage)?.withRenderingMode(.alwaysOriginal)
        self.title = title
    }
}

fileprivate let centerSize: CGFloat = 100.0

class CCTabBar: UITabBar {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var tabbarButtons: [Any] = []
    
    let titles = ["首页", "分类", "未来加", "购物车", "我的"]
    
    let images = ["home_bar", "catelog_bar", "wela_bar", "cart_bar", "my_bar"]
    
    let selectImages = ["home_bar_selected", "catelog_bar_selected", "wela_bar_selected", "cart_bar_selected", "my_bar_selected"]
    
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
        
        for i in 0..<self.items!.count {
            let item = self.items?[i]
            item?.itemAttribute(titles[i], image: images[i], selectedImage: selectImages[i])
        }
        
        let centerItemWidth = centerSize*375.0/UIScreen.main.bounds.width
        
        let itemWidth = 0.25*(375.0-centerSize)*375.0/UIScreen.main.bounds.width
        
        let itemHeight = self.bounds.height
        
        var index: Int = 0
        for item in self.subviews {
            if item.isKind(of: NSClassFromString("UITabBarButton")!) {
                tabbarButtons.append(item)
                if index < 2 {
                    item.frame = CGRect(x: CGFloat(index)*itemWidth, y: 0, width: itemWidth, height: itemHeight)
                }else if index == 2 {
                    item.frame = CGRect(x: CGFloat(index)*itemWidth, y: 0, width: centerItemWidth, height: itemHeight)
                }else {
                    item.frame = CGRect(x: CGFloat(2)*itemWidth+centerItemWidth+CGFloat(index-3)*itemWidth, y: 0, width: itemWidth, height: itemHeight)
                }
                index += 1
                print(item.frame)
            }
        }
        
        print(self.subviews)
    
    }
}
