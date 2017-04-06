//
//  OrderClearViewController.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/4/1.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit
import MBProgressHUD

private let cellIdentifier = "OrderClearCell"

private let headIdentifier = "OrderClearHeadView"

private let footIdentifier = "OrderClearFootView"

class OrderClearViewController: ViewController, CCTableViewProtocol {

    var tableView: UITableView = UITableView(frame: CGRect.zero, style: .grouped)
    
    var clearRec_id = ""
    
    var clearModel: ShoppingClearModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configTableView()
    }
    
    func configTableView() {
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.snp.updateConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        tableView.register(UINib.init(nibName: "OrderTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.register(OrderCellHeadView.self, forHeaderFooterViewReuseIdentifier: headIdentifier)
        tableView.register(OrderCellFootView.self, forHeaderFooterViewReuseIdentifier: footIdentifier)
        
        configFootView()
        
    }
    
    func configFootView() {
        let footView = UIView(frame: CGRect.init(x: 0, y: 0, width: tableView.bounds.width, height: 40))
        footView.backgroundColor = UIColor.white
        tableView.tableFooterView = footView
        
        let textLabel = UILabel()
        
        textLabel.font = CCTextFont
        textLabel.text = String.init(format: "合计：%.0f", clearModel.total_price)
        
        let payButton = UIButton(type: .system)
        footView.addSubview(textLabel)
        footView.addSubview(payButton)
        
        textLabel.snp.updateConstraints { (make) in
            make.right.equalTo(payButton.snp.left).offset(-20)
            make.centerY.equalToSuperview()
        }
        
        payButton.backgroundColor = CCOrangeColor
        payButton.setTitle("确认支付", for: .normal)
        payButton.setTitleColor(UIColor.white, for: .normal)
        payButton.layer.masksToBounds = true
        payButton.layer.cornerRadius = 4
        payButton.addTarget(self, action: #selector(confirmPay(button:)), for: .touchUpInside)
        
        
        payButton.snp.updateConstraints { (make) in
            make.right.equalTo(-10)
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalTo(100)
        }
    }
    
    @objc func confirmPay(button: UIButton) {
        
        guard clearModel.address != nil else {
            MBProgressHUD.showErrorAdded(message: "请选择一个收货地址", to: self.view)
            return
        }
        
        func getRec_id() -> String {
            let arr = clearModel.carts
            var rec_idArr: [String] = []
            for cart in arr {
                for goods in cart.cart_goods {
                    let str = String(goods.rec_id)
                    rec_idArr.append(str)
                }
            }
            
            return rec_idArr.joined(separator: ",")
        }
        
        self.performSegue(withIdentifier: "shopping_confirm", sender: ConfirmPasswordViewController.ConfirmStyle.shopping(getRec_id(), clearModel.address!.address_id))
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "shopping_confirm" {
            let controller = segue.destination as! ConfirmPasswordViewController
            controller.style = sender as! ConfirmPasswordViewController.ConfirmStyle
        }
        
    }
}

extension OrderClearViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }else {
            let headView = tableView.dequeueReusableHeaderFooterView(withIdentifier: headIdentifier) as! OrderCellHeadView
            headView.goodState = (clearModel.carts[section-1].shop_name, 0)
            headView.statusLabel.isHidden = true
            return headView
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if section == 0 {
            return nil
        }else {
            let footView = tableView.dequeueReusableHeaderFooterView(withIdentifier: footIdentifier) as! OrderCellFootView
            footView.state = 0
            footView.goodAttribute = (clearModel.carts[section-1].shop_num, clearModel.carts[section-1].shop_price)
            return footView
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return clearModel.carts.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ?1: clearModel.carts[section-1].cart_goods.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 70: 100
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 10:50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ?10:30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            var cell = tableView.dequeueReusableCell(withIdentifier: "AdressCell") as? AdressTableViewCell
            if cell == nil {
                if clearModel.address != nil {
                    cell = AdressTableViewCell.init(style: .defaultAdress, reuseIdentifier: "AdressCell")
                    cell?.adress = clearModel.address
                }else {
                    cell = AdressTableViewCell.init(style: .noAdress, reuseIdentifier: "AdressCell")
                }
            }
            return cell!
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! OrderTableViewCell
            let oldModel = clearModel.carts[indexPath.section-1].cart_goods[indexPath.row]
            let model = OrderGoodsModel(goods: ["goods_img": oldModel.goods_img, "goods_id": oldModel.goods_id,"goods_price": oldModel.goods_price,"goods_name": oldModel.goods_name,"goods_num": oldModel.goods_num])
            cell.model = model
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            //没有地址则进入新建地址， 有地址则选择地址
            let cell = tableView.cellForRow(at: indexPath) as! AdressTableViewCell
            if cell.style == .noAdress {
                
            }else {
                
            }
        }
    }
    
}
