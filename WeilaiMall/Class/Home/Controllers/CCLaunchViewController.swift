//
//  CCLaunchViewController.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/4/8.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit

class CCLaunchViewController: UIViewController, UIScrollViewDelegate {

    typealias ClickCallback = () -> UIView
    
    typealias CompletionCallback = () -> Void
    
    var click: ClickCallback?
    
    var completion: CompletionCallback?
    
    var scrollView = UIScrollView(frame: CGRect.zero)
    
    let pageControl = UIPageControl()
    
    let imageNames = ["launchName_1", "launchName_2"]
    
    var button: UIButton = {
        let button = UIButton(type: .system)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 22
        button.backgroundColor = UIColor(red:0.93, green:0.55, blue:0.25, alpha:1.00)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("开启未来+生活", for: .normal)
        button.titleLabel?.font = UIFont.CCsetfont(16)
        return button
    }()
    
    static func showLaunchView(click: @escaping ClickCallback, completion: @escaping CompletionCallback) {
        let launchViewController = CCLaunchViewController()
        launchViewController.click = click
        launchViewController.completion = completion
        UIApplication.shared.delegate?.window??.rootViewController = launchViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = UIColor.white
        
        configScrollView()
    }
    
    
    private func configScrollView() {
        self.view.addSubview(scrollView)
        scrollView.snp.updateConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        func addButton(view: UIView) {
            view.addSubview(button)
            view.isUserInteractionEnabled = true
            button.snp.updateConstraints { (make) in
                make.centerX.equalToSuperview()
                make.bottom.equalTo((-0.2*self.view.bounds.height)+20+44)
                make.width.equalToSuperview().multipliedBy(0.8)
                make.height.equalTo(44)
            }
            button.addTarget(self, action: #selector(changeRoot(button:)), for: .touchUpInside)
        }
        
        scrollView.contentSize = CGSize(width: self.view.bounds.width*CGFloat(imageNames.count), height: self.view.bounds.width)
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        for name in imageNames {
            let imageView = UIImageView(image: UIImage.init(named: name))
            scrollView.addSubview(imageView)
            let index = imageNames.index(of: name)
            imageView.frame = CGRect(x: self.view.bounds.width*CGFloat(index!), y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
            if index == imageNames.count - 1 {
                addButton(view: imageView)
            }
        }
        
        self.view.addSubview(pageControl)
        pageControl.snp.updateConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-0.2*self.view.bounds.height)
        }
        pageControl.currentPageIndicatorTintColor = CCOrangeColor
        pageControl.pageIndicatorTintColor = CCGrayTextColor
        pageControl.currentPage = 0
        pageControl.numberOfPages = imageNames.count
        
        
    }
    
    @objc private func changeRoot(button: UIButton) {
        
        if self.click != nil {
            let view = self.click!()
            UIView.transition(from: self.view, to: view, duration: 0.5, options: .transitionFlipFromRight, completion: { (completion) in
                if self.completion != nil {
                    self.completion!()
                }
            })
        }
    }
    
    deinit {
        print("\(self) deinit ")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x/scrollView.bounds.width
        pageControl.currentPage = Int(offset)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
