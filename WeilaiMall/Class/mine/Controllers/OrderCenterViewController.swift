//
//  OrderCenterViewController.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/3/9.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit

class OrderScrollView: UIScrollView, UIGestureRecognizerDelegate {
    
    /// 全部 tableview
    var allTableView = UITableView(frame: CGRect.zero, style: .grouped)
    /// 未发货 tableview
    var notDeliverTableView = UITableView(frame: CGRect.zero, style: .grouped)
    /// 待收货 tableview
    var notrReceivingTableView = UITableView(frame: CGRect.zero, style: .grouped)
    /// 已收货 tableview
    var receivingTableView = UITableView(frame: CGRect.zero, style: .grouped)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialization()
    }
    
    private func initialization() {
        self.addSubview(allTableView)
        self.addSubview(notDeliverTableView)
        self.addSubview(notrReceivingTableView)
        self.addSubview(receivingTableView)
        
        allTableView.tableFooterView = UIView()
        notDeliverTableView.tableFooterView = UIView()
        notrReceivingTableView.tableFooterView = UIView()
        receivingTableView.tableFooterView = UIView()
        
        
        allTableView.snp.updateConstraints { (make) in
            make.centerY.size.left.top.equalToSuperview()
        }
        
        notDeliverTableView.snp.updateConstraints { (make) in
            make.centerY.size.top.equalToSuperview()
            make.left.equalTo(self.allTableView.snp.right)
        }
        notrReceivingTableView.snp.updateConstraints { (make) in
            make.centerY.size.top.equalToSuperview()
            make.left.equalTo(self.notDeliverTableView.snp.right)
        }
        
        receivingTableView.snp.updateConstraints { (make) in
            make.centerY.size.top.equalToSuperview()
            make.left.equalTo(self.notrReceivingTableView.snp.right)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 实现这个方法主要是 可以解决scrollview导致 右滑返回手势 无效的问题
    // MARK: - UIGestureRecognizerDelegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // 首先判断otherGestureRecognizer是不是系统pop手势
        if (otherGestureRecognizer.view?.isKind(of: NSClassFromString("UILayoutContainerView")!))! {
            // 再判断系统手势的state是began还是fail，同时判断scrollView的位置是不是正好在最左边
            if otherGestureRecognizer.state == .possible && self.contentOffset.x <= 0 {
                self.panGestureRecognizer.require(toFail: otherGestureRecognizer)
                return true;
            }
        }
        return false
    }
    
}

/// 订单中心
class OrderCenterViewController: ViewController {

    var scrollView = OrderScrollView()
    
    lazy var headView: OrderHeadView = OrderHeadView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addBackItem()
        
        loadSubviews()
        
        self.view.backgroundColor = UIColor.white
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    
    private func loadSubviews() {
        self.view.addSubview(headView)
        self.view.addSubview(scrollView)
        
        headView.snp.updateConstraints { (make) in
            make.top.equalTo(64)
            make.left.width.right.equalToSuperview()
            make.height.equalTo(40)
        }
        
        scrollView.snp.updateConstraints { (make) in
            make.top.equalTo(self.headView.snp.bottom)
            make.left.right.width.bottom.equalToSuperview()
        }
        
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize(width: self.view.bounds.size.width * 4, height: 0)
        scrollView.showsHorizontalScrollIndicator = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
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

extension OrderCenterViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    func changeScrollContent(location: SlipperLocation) {
        scrollView.contentOffset = CGPoint(x: UIScreen.main.bounds.width * CGFloat(location.rawValue), y: 0)
    }
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell.init(style: .default, reuseIdentifier: "")
        //cell?.planOrHistory = .plan
        //cell?.model = self.dataArray[headView.slipperLocation.rawValue][indexPath.row]
        return cell
    }
    // MARK: - UIScrollViewDelegate
    @available(iOS 2.0, *)
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !(scrollView is UITableView) else {
            return
        }
        if scrollView.contentOffset.x < 0 || scrollView.contentOffset.x > self.view.bounds.width*2
        {
            return
        }
        NSLog("scrollView content === %f", scrollView.contentOffset.x)
//        let originalContent = self.view.bounds.width*CGFloat(headView.slipperLocation.rawValue)
//        let originCenterX = self.view.bounds.width/8 + self.view.bounds.width*CGFloat(headView.slipperLocation.rawValue)/4
//        headView.slipper.center.x = originCenterX + (scrollView.contentOffset.x - originalContent)/3
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard !(scrollView is UITableView) else {
            return
        }
        NSLog("=== scrollView End ===")
        headView.buttonAction(headView.viewWithTag(Int(scrollView.contentOffset.x/self.view.bounds.width)+100) as! UIButton)
    }
}
