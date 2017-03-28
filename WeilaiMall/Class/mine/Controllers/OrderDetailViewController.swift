//
//  OrderDetailViewController.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/3/16.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit
import MBProgressHUD

class OrderDetailViewController: ViewController {

    var tableView: UITableView = UITableView.init(frame: CGRect.zero, style: .grouped)
    
    let headIdentifier = "headViewIdentifier"
    let cellIdentifier = "orderDetailCell"
    let footIdentifier = "footViewIdentifier"
    
    let defaultCell = "defaultCell"
    let detailCell = "detailCell"
    
    var orderid: Int! = 0
    
    var model: OrderDetailModel?
    
    var detailButton = UIButton.init(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        configTableView()
        prepareData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func prepareData() {
        
        URLSessionClient().alamofireSend(OrderDetailRequest(parameter: ["access_token": access_token, "order_id": orderid]), handler: { [weak self] (models, error) in
            if error == nil {
                if models.count > 0{
                    self?.model = models[0]
                    self?.tableView.reloadData()
                    self?.configFootview(state: (self?.model?.state)!)
                }
            }else {
                MBProgressHUD.showErrorAdded(message: (error as! RequestError).info(), to: self?.view)
            }
        })
    }
    
    func configTableView() {
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.snp.updateConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        tableView.register(UINib.init(nibName: "OrderTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.register(OrderCellHeadView.self, forHeaderFooterViewReuseIdentifier: headIdentifier)
        tableView.register(OrderCellFootView.self, forHeaderFooterViewReuseIdentifier: footIdentifier)
        
        /// 0：待发货  1:待收货 2:已收货
        let footView = UIView(frame: CGRect.init(x: 0, y: 0, width: tableView.bounds.width, height: 50))
        //footView.backgroundColor = UIColor.red
        
        footView.addSubview(detailButton)
        detailButton.backgroundColor = CCOrangeColor
        detailButton.setTitle("", for: .normal)
        detailButton.setTitleColor(UIColor.white, for: .normal)
        detailButton.layer.masksToBounds = true
        detailButton.layer.cornerRadius = 4
        
        detailButton.snp.updateConstraints { (make) in
            make.right.equalTo(-10)
            make.height.equalTo(30)
            make.width.equalTo(100)
            make.centerY.equalToSuperview()
        }
        detailButton.isHidden = true
        
        tableView.tableFooterView = footView
    }
    
    private func configFootview(state: Int) {
        /// 0：待发货  1:待收货 2:已收货
        let titles = ["", "确认收货", "确认收货"]
        detailButton.isHidden = state != 1
        detailButton.setTitle(titles[state], for: .normal)
        
        detailButton.addTarget(self, action: #selector(detailAction(_:)), for: .touchUpInside)
    }
    
    @objc private func detailAction(_ button: UIButton) {
        
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

extension OrderDetailViewController: UITableViewDelegate, UITableViewDataSource {
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 2 {
            let headview = tableView.dequeueReusableHeaderFooterView(withIdentifier: headIdentifier) as! OrderCellHeadView
            if  model != nil {
                headview.goodState = ((model?.shop_name)!, (model?.state)!)
            }
            return headview
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.01
        }else if section == 2 {
            return 50
        }else {
            return 15
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 2 {
            return 30
        }
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 2 {
            let footView = tableView.dequeueReusableHeaderFooterView(withIdentifier: footIdentifier) as! OrderCellFootView
            footView.state = 0
            if model != nil {
                footView.goodAttribute = ((model?.goods_num)!, (model?.goods_price)!)
            }
            return footView
        }
        return nil
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 44
        }else if indexPath.section == 1 {
            return 70
        }else if indexPath.section == 2 {
            return 100
        }else {
            return 70
        }
        
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return model==nil ?1:(model?.order_goods.count)!
        }
        return (section % 2) == 0 ?2:1
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            var cell = tableView.dequeueReusableCell(withIdentifier: defaultCell)
            if cell == nil {
                cell = UITableViewCell.init(style: .value1, reuseIdentifier: defaultCell)
            }
            defaultCell(with: cell, row: indexPath.row)
            return cell!
        }else if indexPath.section == 1 || indexPath.section == 3 {
            var cell = tableView.dequeueReusableCell(withIdentifier: detailCell) as? OrderDetailCell
            if cell == nil {
                cell = OrderDetailCell.init(style: indexPath.section == 1 ?.address:.logistics, reuseIdentifier: detailCell)
            }
            cell?.model = model
            return cell!
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! OrderTableViewCell
            cell.model = model?.order_goods[indexPath.row]
            return cell
        }
    }
    
    private func defaultCell(with cell: UITableViewCell?, row: Int) {
        
        cell?.textLabel?.font = UIFont.CCsetfont(14)
        cell?.detailTextLabel?.font = UIFont.CCsetfont(13)
        cell?.detailTextLabel?.textColor = CCOrangeColor
        
        guard model != nil else {
            return
        }
        
        let titles = ["卖家还未发货", "卖家已发货", "已确认收货"]
        
        if row == 0 {
            cell?.textLabel?.textColor = UIColor.black
            cell?.detailTextLabel?.text = titles[(model?.state)!]
            cell?.textLabel?.text = "订单编号：\((model?.order_sn)!)"
        }else if row == 1 {
            cell?.textLabel?.textColor = CCGrayTextColor
            let formatter = DateFormatter.init()
            formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
            cell?.textLabel?.text = "订单时间：" + formatter.string(from: (model?.add_time)!)
        }
    }
}
