//
//  OrderCenterViewController.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/3/9.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit
import MBProgressHUD
import MJRefresh

fileprivate class HeadButton: UIButton {
    
    var Label: UILabel = UILabel()
    
    var image: UIImageView = UIImageView(image: UIImage.init(named: "right_icon"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(Label)
        addSubview(image)
        Label.text = "未来加商城"
        Label.font = UIFont.CCsetfont(16)
        
        Label.snp.updateConstraints({ (make) in
            make.left.equalTo(10)
            make.height.centerY.equalToSuperview()
        })
        
        image.snp.makeConstraints({ (make) in
            make.left.equalTo(self.Label.snp.right).offset(5)
            make.centerY.equalToSuperview()
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class OrderCellHeadView: UITableViewHeaderFooterView {

    private var titleButton: HeadButton = HeadButton(type: .system)
    
    var statusLabel = UILabel()
    
    let whiteView = UIView()
    
    let goodStateTitles = ["卖家还未发货", "卖家已发货", "已确认收货"]
    
    var goodState: (String, Int) = ("未来加商城", 2) {
        didSet {
            titleButton.Label.text = goodState.0
            statusLabel.text = goodStateTitles[goodState.1]
        }
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        configSubviews()
    }
    
    private func configSubviews() {
        contentView.addSubview(whiteView)
        whiteView.backgroundColor = UIColor.white
        
        whiteView.snp.updateConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(40)
        }
        
        whiteView.addSubview(titleButton)
        whiteView.addSubview(statusLabel)
        titleButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.height.equalToSuperview()
            make.width.equalTo(100)
        }
        
        statusLabel.snp.updateConstraints { (make) in
            make.right.equalTo(-10)
            make.centerY.height.equalToSuperview()
        }
        
        statusLabel.text = "卖家已发货"
        statusLabel.textColor = UIColor.orange
        statusLabel.font = UIFont.CCsetfont(14)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class OrderCellFootView: UITableViewHeaderFooterView {
    
    let footLabel = UILabel()
    
    let lineLabel = UILabel()
    
    let sureButton = UIButton(type: .system)
    
    var goodAttribute: (Int, Float) = (1, 0.0) {
        didSet {
            footLabel.text = String.init(format: "共%d件商品 合计：%.0f积分", goodAttribute.0, goodAttribute.1)
        }
    }
    
    var state: Int = 0 {
        didSet {
            if state == 1 {
                sureButton.isHidden = false
            }else {
                sureButton.isHidden = true
            }
        }
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        loadSubviews()
    }
    
    private func loadSubviews() {
        contentView.backgroundColor = UIColor.white
        contentView.addSubview(footLabel)
        footLabel.snp.updateConstraints { (make) in
            make.right.equalTo(-15)
            make.top.equalToSuperview()
            make.height.equalTo(30)
        }
        
        footLabel.textColor = UIColor.colorWithString("868686")
        footLabel.font = UIFont.CCsetfont(13)
        footLabel.text = String.init(format: "共%d件商品 合计：¥ %.2f （%d积分）", 1, 239.0, 9000)
        
        contentView.addSubview(lineLabel)
        lineLabel.backgroundColor = UIColor.groupTableViewBackground
        lineLabel.snp.updateConstraints { (make) in
            make.width.left.equalToSuperview()
            make.height.equalTo(1)
            make.top.equalTo(self.footLabel.snp.bottom)
        }
        
        sureButton.backgroundColor = CCOrangeColor
        sureButton.setTitle("确认收货", for: .normal)
        sureButton.setTitleColor(UIColor.white, for: .normal)
        sureButton.layer.masksToBounds = true
        sureButton.layer.cornerRadius = 4
        contentView.addSubview(sureButton)
        
        sureButton.snp.updateConstraints { (make) in
            make.right.equalTo(-15)
            make.height.equalTo(30)
            make.width.equalTo(100)
            make.top.equalTo(self.footLabel.snp.bottom).offset(5)
        }
        sureButton.isHidden = state == 1
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


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
    
    func reloadData(location: SlipperLocation) {
        DispatchQueue.main.async {
            switch location {
                case .all: self.allTableView.reloadData()
                case .notDeliver: self.notDeliverTableView.reloadData()
                case .notrReceiving: self.notrReceivingTableView.reloadData()
                case .receiving: self.receivingTableView.reloadData()
            }
        }
    }
    
    func endRefresh(location: SlipperLocation, isNodata: Bool = false) {
        if #available(iOS 10.0, *) {
            DispatchQueue.main.async {
                switch location {
                case .all:
                    self.allTableView.refreshControl?.endRefreshing()
                case .notDeliver:
                    self.notDeliverTableView.refreshControl?.endRefreshing()
                case .notrReceiving:
                    self.notrReceivingTableView.refreshControl?.endRefreshing()
                case .receiving:
                    self.receivingTableView.refreshControl?.endRefreshing()
                }
            }
        }else {
            DispatchQueue.main.async {
                switch location {
                case .all:
                    self.allTableView.mj_header.endRefreshing()
                case .notDeliver:
                    self.notDeliverTableView.mj_header.endRefreshing()
                case .notrReceiving:
                    self.notrReceivingTableView.mj_header.endRefreshing()
                case .receiving:
                    self.receivingTableView.mj_header.endRefreshing()
                }
            }
        }
        
        if isNodata {
            DispatchQueue.main.async {
                switch location {
                case .all:
                    self.allTableView.mj_footer.endRefreshingWithNoMoreData()
                case .notDeliver:
                    self.notDeliverTableView.mj_footer.endRefreshingWithNoMoreData()
                case .notrReceiving:
                    self.notrReceivingTableView.mj_footer.endRefreshingWithNoMoreData()
                case .receiving:
                    self.receivingTableView.mj_footer.endRefreshingWithNoMoreData()
                }
            }
        }else {
            DispatchQueue.main.async {
                switch location {
                case .all:
                    self.allTableView.mj_footer.endRefreshing()
                case .notDeliver:
                    self.notDeliverTableView.mj_footer.endRefreshing()
                case .notrReceiving:
                    self.notrReceivingTableView.mj_footer.endRefreshing()
                case .receiving:
                    self.receivingTableView.mj_footer.endRefreshing()
                }
            }
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

    let headIdentifier = "headViewIdentifier"
    let cellIdentifier = "cellIdentifier"
    let footIdentifier = "footViewIdentifier"
    
    var scrollView = OrderScrollView(frame: CGRect.zero)
    
    lazy var headView: OrderHeadView = OrderHeadView()
    
    var parameters: [String: Any] = [:]
    
    var dataArray: [OrderListModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        loadSubviews()
        
        self.view.backgroundColor = UIColor.white
        
        prepareData(.refreshData)
    }
    
    func prepareData(_ style: CCRequestStyle, state: Int = -1) {
        
        if state == -1 {
            parameters.removeValue(forKey: "state")
        }else {
            parameters.updateValue(state, forKey: "state")
        }
        
        var page: Int = parameters["p"] as? Int ?? 1
        if style == .refreshData {
            page = 1
            parameters.updateValue(page, forKey: "p")
        }else if style == .moreData {
            page += 1
            parameters.updateValue(page, forKey: "p")
        }
        parameters.updateValue(access_token, forKey: "access_token")
        
        URLSessionClient().alamofireSend(OrderListRequest(parameter: parameters), handler: { [weak self] (models, error) in
            if error == nil {
                if style == .refreshData {
                    self?.dataArray = models as! [OrderListModel]
                }else {
                    for model in models {
                        self?.dataArray.append(model!)
                    }
                }
                self?.scrollView.reloadData(location: SlipperLocation(rawValue: state+1)!)
            }else {
                MBProgressHUD.showErrorAdded(message: (error?.getInfo())!, to: self?.view)
            }
            
            self?.scrollView.endRefresh(location: SlipperLocation(rawValue: state+1)!, isNodata: models.count==0)
        })
    }
    
    private func loadSubviews() {
        self.view.addSubview(headView)
        self.view.addSubview(scrollView)
        self.automaticallyAdjustsScrollViewInsets = false
        headView.snp.updateConstraints { (make) in
            make.top.equalTo(64)
            make.left.width.right.equalToSuperview()
            make.height.equalTo(40)
        }
        
        headView.changeContent = {
            [unowned self] location in
            UIView.animate(withDuration: 0.2, animations: {
                self.scrollView.contentOffset = CGPoint(x: UIScreen.main.bounds.width * CGFloat(location.rawValue), y: 0)
            })
            
            let state = location.rawValue - 1
            self.prepareData(.refreshData, state: state)
        }
        
        scrollView.snp.updateConstraints { (make) in
            make.top.equalTo(self.headView.snp.bottom)
            make.left.right.width.bottom.equalToSuperview()
        }
        
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize(width: self.view.bounds.size.width * 4, height: 0)
        scrollView.showsHorizontalScrollIndicator = false
        
        tableViewAttribute(scrollView.allTableView)
        tableViewAttribute(scrollView.notDeliverTableView)
        tableViewAttribute(scrollView.notrReceivingTableView)
        tableViewAttribute(scrollView.receivingTableView)
    }
    
    
    private func tableViewAttribute(_ tableView: UITableView) {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0);
        tableView.register(OrderCellHeadView.self, forHeaderFooterViewReuseIdentifier: headIdentifier)
        tableView.register(OrderCellFootView.self, forHeaderFooterViewReuseIdentifier: footIdentifier)
        tableView.register(UINib.init(nibName: "OrderTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        if #available(iOS 10.0, *) {
            let refreshControl = UIRefreshControl.init()
            refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
            tableView.refreshControl = refreshControl
        } else {
            // Fallback on earlier versions
            //iOS 8.0 使用MJRefresh
            tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: { 
                [unowned self] in
                let state = self.scrollView.contentOffset.x/self.view.bounds.width
                self.prepareData(.refreshData, state: Int(state)-1)
            })
        }
        
        tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            [unowned self] in
            let state = self.scrollView.contentOffset.x/self.view.bounds.width
            self.prepareData(.moreData, state: Int(state)-1)
        })
        tableView.mj_footer.isAutomaticallyHidden = true
        
    }
    
    func refreshData() {
        prepareData(.refreshData)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "orderDetail" {
            let controller = segue.destination as! OrderDetailViewController
            controller.orderid = sender as! Int
        }
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

extension OrderCenterViewController {
    func affirmorder(_ button: UIButton) {
        
    }
}


// MARK: - UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate
extension OrderCenterViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headview = tableView.dequeueReusableHeaderFooterView(withIdentifier: headIdentifier) as! OrderCellHeadView
        headview.goodState = (dataArray[section].shop_name, dataArray[section].state)
        return headview
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return dataArray[section].state == 1 ?70:30
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footView = tableView.dequeueReusableHeaderFooterView(withIdentifier: footIdentifier) as! OrderCellFootView
        footView.state = dataArray[section].state
        footView.goodAttribute = (dataArray[section].goods_num, dataArray[section].goods_price)
        return footView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray[section].order_goods.count
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.performSegue(withIdentifier: "orderDetail", sender: dataArray[indexPath.section].order_id)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! OrderTableViewCell
        cell.model = dataArray[indexPath.section].order_goods[indexPath.row]
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
        let originalContent = self.view.bounds.width*CGFloat(headView.slipperLocation.rawValue)
        let originCenterX = self.view.bounds.width/8 + self.view.bounds.width*CGFloat(headView.slipperLocation.rawValue)/4
        headView.slipper.center.x = originCenterX + (scrollView.contentOffset.x - originalContent)/4
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard !(scrollView is UITableView) else {
            return
        }
        NSLog("=== scrollView End ===")
        headView.buttonAction(headView.viewWithTag(Int(scrollView.contentOffset.x/self.view.bounds.width)+100) as! UIButton)
        
    }
}
