//
//  OrderHeadView.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/3/9.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit

enum SlipperLocation: Int {
    case all = 0
    case notDeliver
    case notrReceiving
    case receiving
}



class OrderHeadView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    typealias ChangeContent = (_ location: SlipperLocation) -> Void
    
    var changeContent: ChangeContent?
    
    /// 创建一个滑块位置的枚举，默认位置为 全部
    var slipperLocation: SlipperLocation = .all {
        willSet{
            
        }
        didSet{
            NSLog("did set " + String(describing: slipperLocation))
            if changeContent != nil{
                changeContent!(self.slipperLocation)
            }
        }
    }

    
    var titleArray: Array<String> = ["全部", "待发货", "待收货", "已收货"]
    
    lazy var effectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    
    lazy var slipper = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(effectView)
        effectView.snp.updateConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        let lineLayer = CALayer.init()
        lineLayer.frame = CGRect.init(x: 0, y: 39.5, width: UIScreen.main.bounds.width, height: 0.5)
        lineLayer.backgroundColor = UIColor.colorWithString("#D7D7D7").cgColor
        effectView.layer.addSublayer(lineLayer)
        
        createButtonView()
        
        configSlipper()
    }
    
    private func createButtonView() {
        
        for i: Int in 0..<titleArray.count {
            let button: UIButton = UIButton(type: .custom)
            self.addSubview(button)
            button.setTitle(titleArray[i], for: .normal)
            button.tag = 100 + i
            button.backgroundColor = UIColor.clear
            button.setTitleColor(UIColor.colorWithString("#303030"), for: .normal)
            button.setTitleColor(UIColor.colorWithString("#cd5005"), for: .selected)
            button.setTitleColor(UIColor.colorWithString("#cd5005"), for: .highlighted)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            button.isSelected = i == slipperLocation.rawValue
            
            button.snp.updateConstraints({ (make) in
                make.width.equalTo(self).multipliedBy(0.25)
                make.centerY.height.equalToSuperview()
                make.left.equalTo(CGFloat(Float(i)/4.0)*UIScreen.main.bounds.width)
            })
            
            button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        }
    }
    
    @objc func buttonAction(_ button: UIButton) {
        if button.isSelected == true {return}
        self.slipperLocation = SlipperLocation(rawValue: button.tag - 100)!
        button.isSelected = true
        //遍历button 使其他button isSelected 为 false
        for i: Int in 0..<titleArray.count {
            if i != button.tag-100 {
                let btn: UIButton = self.viewWithTag(i+100) as! UIButton
                btn.isSelected = false
            }
        }
        
        UIView.animate(withDuration: 0.2) {
            self.slipper.center.x = (self.viewWithTag(self.slipperLocation.rawValue+100)?.center.x)!
        }
    }
    
    /// 创建一个可以滑动的小绿块
    private func configSlipper() {
        slipper.backgroundColor = UIColor.colorWithString("#ec5600")
        self.addSubview(slipper)
        
        slipper.snp.updateConstraints { (make) in
            make.width.equalTo(30)
            make.height.equalTo(2)
            make.bottom.equalToSuperview()
            make.centerX.equalTo((self.viewWithTag(slipperLocation.rawValue+100)!.snp.centerX))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
