//
//  OrderDetailViewController.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/3/16.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit

class OrderDetailViewController: ViewController {

    var tableView: UITableView = UITableView.init(frame: CGRect.zero, style: .grouped)
    
    let headIdentifier = "headViewIdentifier"
    let cellIdentifier = "orderDetailCell"
    let footIdentifier = "footViewIdentifier"
    
    let defaultCell = "defaultCell"
    let detailCell = "detailCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        configTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            let headview = tableView.dequeueReusableHeaderFooterView(withIdentifier: headIdentifier)
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
            let footView = tableView.dequeueReusableHeaderFooterView(withIdentifier: footIdentifier)
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
                defaultCell(with: cell, row: indexPath.row)
            }
            return cell!
        }else if indexPath.section == 1 || indexPath.section == 3 {
            var cell = tableView.dequeueReusableCell(withIdentifier: detailCell)
            if cell == nil {
                cell = OrderDetailCell.init(style: indexPath.section == 1 ?.address:.logistics, reuseIdentifier: detailCell)
            }
            return cell!
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            //cell?.planOrHistory = .plan
            //cell?.model = self.dataArray[headView.slipperLocation.rawValue][indexPath.row]
            return cell
        }
    }
    
    private func defaultCell(with cell: UITableViewCell?, row: Int) {
        cell?.textLabel?.font = UIFont.CCsetfont(14)
        cell?.detailTextLabel?.font = UIFont.CCsetfont(13)
        cell?.detailTextLabel?.textColor = CCOrangeColor
        if row == 0 {
            cell?.textLabel?.textColor = UIColor.black
            cell?.detailTextLabel?.text = "卖家已发货"
            cell?.textLabel?.text = "订单编号：" + "123123123123123"
        }else if row == 1 {
            cell?.textLabel?.textColor = CCGrayTextColor
            cell?.textLabel?.text = "订单编号：" + "2017-02-15 09:44:13"
        }
    }
}
