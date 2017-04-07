//
//  CCScanCodeView.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/4/6.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit

class CCScanCodeView: UIView {

    /** 扫描内容外部View的alpha值 */
    let scanBorderOutsideViewAlpha: CGFloat = 0.4
    /** 扫描动画线(冲击波) 的高度 */
    let scanninglineHeight: CGFloat = 12
    
    let scanContent = UIView()
    
    let scanningline = UIImageView.init(image: UIImage.init(named: "CCQRCode.bundle/CodeScanningLine"))
    
    var animationStop = true
    
    var displayLink = CADisplayLink()
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviews()
    }
    
    private func setupSubviews() {
        
        addSubview(scanContent)
        scanContent.snp.updateConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalTo(scanContent.snp.width)
        }
        
        scanContent.layer.borderColor = UIColor.colorWithString(("#ffffff", 0.6)).cgColor
        scanContent.layer.borderWidth = 0.7;
        scanContent.layer.masksToBounds = true
        scanContent.backgroundColor = UIColor.clear
        
        // 顶部view的创建
        let topview = UIView()
        addSubview(topview)
        topview.snp.updateConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(scanContent.snp.top)
        }
        topview.backgroundColor = UIColor.colorWithString(("#000000", 0.4))
        
        // 左侧view的创建
        let leftview = UIView()
        addSubview(leftview)
        leftview.snp.updateConstraints { (make) in
            make.left.equalToSuperview()
            make.top.bottom.equalTo(scanContent)
            make.right.equalTo(scanContent.snp.left)
        }
        leftview.backgroundColor = UIColor.colorWithString(("#000000", 0.4))
        // 右侧view的创建
        let rightview = UIView()
        addSubview(rightview)
        rightview.snp.updateConstraints { (make) in
            make.right.equalToSuperview()
            make.top.bottom.equalTo(scanContent)
            make.left.equalTo(scanContent.snp.right)
        }
        rightview.backgroundColor = UIColor.colorWithString(("#000000", 0.4))
        // 下面view的创建
        let bottomview = UIView()
        addSubview(bottomview)
        bottomview.snp.updateConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(scanContent.snp.bottom)
        }
        bottomview.backgroundColor = UIColor.colorWithString(("#000000", 0.4))
        // 提示Label
        
        let promptLabel = UILabel()
        promptLabel.textAlignment = .center;
        promptLabel.font = UIFont.boldSystemFont(ofSize: 14)
        promptLabel.textColor = UIColor.colorWithString(("#ffffff", 0.6))
        promptLabel.text = "将二维码/条码放入框内, 即可自动扫描";
        addSubview(promptLabel)
        promptLabel.snp.updateConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(scanContent.snp.bottom).offset(30)
        }
        
        func configImageView() {
            let left_image = UIImage.init(named: "CCQRCode.bundle/CodeLeftTop")
            let right_image = UIImage.init(named: "CCQRCode.bundle/CodeRightTop")
            let left_image_down = UIImage.init(named: "CCQRCode.bundle/CodeLeftBottom")
            let right_image_down = UIImage.init(named: "CCQRCode.bundle/CodeRightBottom")
            
            let left_imageView = UIImageView.init(image: left_image)
            let right_imageView = UIImageView.init(image: right_image)
            let left_imageView_down = UIImageView.init(image: left_image_down)
            let right_imageView_down = UIImageView.init(image: right_image_down)
            addSubview(left_imageView)
            addSubview(right_imageView)
            addSubview(left_imageView_down)
            addSubview(right_imageView_down)
            
            left_imageView.snp.updateConstraints { (make) in
                make.left.top.equalTo(scanContent)
            }
            right_imageView.snp.updateConstraints { (make) in
                make.right.top.equalTo(scanContent)
            }
            left_imageView_down.snp.updateConstraints { (make) in
                make.left.bottom.equalTo(scanContent)
            }
            right_imageView_down.snp.updateConstraints { (make) in
                make.right.bottom.equalTo(scanContent)
            }
            
        }
        configImageView()
        lineAnimation()
    }
    
    
    func lineAnimation() {
        
        scanContent.addSubview(scanningline)
        scanningline.snp.updateConstraints { (make) in
            make.left.top.centerX.width.equalTo(scanContent)
        }
        displayLink = CADisplayLink(target: self, selector: #selector(lineStep))
        displayLink.frameInterval = 3
        displayLink.add(to: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)
        
    }
    
    func lineStep() {
        // 每秒运行2次
        let scanContent_MaxY = UIScreen.main.bounds.width*0.7
        if animationStop {
            animationStop = false
            UIView.animate(withDuration: 0.05, delay: 0, options: .curveLinear, animations: { 
                self.scanningline.frame.origin.y += 5
            }, completion: nil)
        }else {
            if scanningline.frame.origin.y >= 0 {
                if scanningline.frame.origin.y >= scanContent_MaxY-12 {
                    self.scanningline.frame.origin.y = 0
                    animationStop = true
                }else {
                    UIView.animate(withDuration: 0.05, delay: 0, options: .curveLinear, animations: {
                        self.scanningline.frame.origin.y += 5
                    }, completion: nil)
                }
                
            }else {
                animationStop = !animationStop
            }
        }
    }
    
    func stopAnimate() {
        scanningline.removeFromSuperview()
        displayLink.invalidate()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("\(self)  deinit ")
    }

}
