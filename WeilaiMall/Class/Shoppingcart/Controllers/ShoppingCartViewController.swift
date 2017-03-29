//
//  ShoppingCartViewController.swift
//  24HMB
//
//  Created by 24hmb on 2017/3/2.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit
import MBProgressHUD
import MJRefresh

private let cellIdentifier = "CCShoppingCarCell"

private let headIdentifier = "CCShoppingCarHeadView"

private let notificationName = Notification.Name.UITextFieldTextDidChange

/// 我的购物车 页面
class ShoppingCartViewController: ViewController, CCTableViewProtocol {

    var tableView: UITableView = UITableView(frame: CGRect.zero, style: .grouped)
    
    let shoppingBar = CCShoppingBar()
    
    /// 商品数量的字典， 记录cell中的个数，防止cell复用带来的问题
    var numberDictionary :[IndexPath: String] = [:]
    
    /// 商品单价的字典， 记录cell中的单价，防止cell复用带来的问题（请求完成后进行赋值）
    var pricesDictionary :[IndexPath: Float] = [:]
    
    /// cellButton， 记录cellButton的选中状态，防止cell复用带来的问题
    var cellButtonStatus :[IndexPath: Bool] = [:]
    
    /// headButton， 记录headButton的选中状态，防止cell复用带来的问题
    var headButtonStatus :[Int: Bool] = [:]
    
    /// 选中的cells 的indexpath 和 商品个数，单价
    var selectedCells: [IndexPath: (Int, Float)] = [:]
    
    /// 删除模式下  cellButton， 记录cellButton的选中状态，防止cell复用带来的问题
    var deleteCellButtonStatus :[IndexPath: Bool] = [:]
    
    /// 删除模式下  headButton， 记录headButton的选中状态，防止cell复用带来的问题
    var deleteHeadButtonStatus :[Int: Bool] = [:]
    
    /// 记录你最后删除的那一个 cell的 indexpath
    var deleteOne: IndexPath?
    
    /// 要删除的cells 的indexpath
    var deleteCells: [ShoppingCartGoods] = []
    
    var dataArray: [ShoppingCartListModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "btn_back")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(backAction(_:)))

        /*
        let rightButton = UIButton(type: .custom)
        rightButton.titleLabel?.font = UIFont.CCsetfont(16)
        rightButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        rightButton.setTitle("编辑", for: .normal)
        rightButton.setTitle("完成", for: .selected)
        rightButton.setTitleColor(UIColor.colorWithString("7e7e7e"), for: .normal)
        rightButton.setTitleColor(UIColor.lightGray, for: .highlighted)
        rightButton.addTarget(self, action: #selector(editing(_:)), for: .touchUpInside)
        let rightItem = UIBarButtonItem(customView: rightButton)
        self.navigationItem.rightBarButtonItem = rightItem
        */
        self.navigationItem.title = "我的购物车"
        configTableView()
        configToolBar()
        
        prepareData(.refreshData)
    }

    func prepareData(_ style: CCRequestStyle){
        
        guard isLogin else {
            return
        }
        
        let request = ShoppingCartListRequest(parameter: ["access_token": access_token])
        URLSessionClient().alamofireSend(request) { [weak self] (models, error) in
            if error == nil {
                self?.dataArray = models as! [ShoppingCartListModel]
                self?.updatePriceDictionary((self?.dataArray)!)
                self?.tableView.reloadData()
            }else {
                MBProgressHUD.showErrorAdded(message: (error as! RequestError).info(), to: self?.view)
            }
            
            if #available(iOS 10.0, *) {
                self?.tableView.refreshControl?.endRefreshing()
            } else {
                // Fallback on earlier versions
                //iOS 8.0 使用MJRefresh
                self?.tableView.mj_header.endRefreshing()
            }
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func editing(_ item: UIButton) {
        item.isSelected = !item.isSelected
        shoppingBar.style = item.isSelected == true ?.editing:.normal
        tableView.reloadData()
        updateBarStatus(true)
        if shoppingBar.style == .normal {
            DispatchQueue.global().sync {
                updateDictionary()
                calculatePrice()
            }
        }
    }
    
    internal func configTableView() {
        tableView.backgroundColor = CCbackgroundColor
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.snp.updateConstraints({ (make) in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(-48)
        })
//        tableView.separatorColor = UIColor.white
//        tableView.separatorStyle = .singleLine
        
        tableView.tableFooterView = UIView()
        tableView.register(UINib.init(nibName: "CCShoppingCarCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.register(CCShoppingCarHeadView.self, forHeaderFooterViewReuseIdentifier: headIdentifier)
        
        if #available(iOS 10.0, *) {
            let refreshControl = UIRefreshControl.init()
            refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
            tableView.refreshControl = refreshControl
        } else {
            // Fallback on earlier versions
            //iOS 8.0 使用MJRefresh
            tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
                [unowned self] in
                self.prepareData(.refreshData)
            })
            
        }
    }
    
    func refreshData() {
        prepareData(.refreshData)
    }
    
    private func configToolBar() {
        self.view.addSubview(shoppingBar)
        shoppingBar.selectButton.addTarget(self, action: #selector(BarButtonAction(_:)), for: .touchUpInside)
        shoppingBar.snp.updateConstraints { (make) in
            make.left.right.equalTo(0)
            make.bottom.equalTo(-48)
            make.height.equalTo(48)
        }
        
        shoppingBar.clearingButton.addTarget(self, action: #selector(clearingAction(_:)), for: .touchUpInside)
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

extension ShoppingCartViewController {
    @objc func clearingAction(_ button: UIButton) {
        print("结算或者删除！！！")
        if shoppingBar.style == .editing {
            updateDeleteCells()
            deleteGoods(with: deleteCells)
        }else {
            
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ShoppingCartViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteGoods(indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = tableView.dequeueReusableHeaderFooterView(withIdentifier: headIdentifier) as! CCShoppingCarHeadView
        headAttribute(headView, section)
        return headView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray[section].cart_goods.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 15+38:10+38
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CCShoppingCarCell
        cellAttribute(cell, indexPath)
        return cell
    }
}


// MARK: - calculatePrice
extension ShoppingCartViewController {
    
    func updatePriceDictionary(_ array: [ShoppingCartListModel]) {
        
        for section in 0..<array.count {
            for row in 0..<array[section].cart_goods.count {
                let indexPath = IndexPath.init(row: row, section: section)
                let price: Float = array[section].cart_goods[row].goods_price
                
                pricesDictionary.updateValue(price, forKey: indexPath)
            }
        }
    }
 
    func calculatePrice() {
        print("selectedCells == \(selectedCells)")
        let values = selectedCells.values
        shoppingBar.clearCount = values.count
        var totalPrice: Float = 0
        for value in values {
            totalPrice += (value.1*Float(value.0))
        }
        
        DispatchQueue.main.async {
            self.shoppingBar.price = totalPrice
        }
        print("totalPrice === \(totalPrice)")
    }
}



// MARK: - OperateBuyCar
extension ShoppingCartViewController {
    
    /// 删除单个cell
    ///
    /// - Parameter indexPath: indexPath
    func requestDeleteGood(with indexPath: IndexPath) {
        let model = self.dataArray[indexPath.section].cart_goods[indexPath.row]
        let request = CartDeleteRequest(parameter: ["access_token": access_token, "rec_id": model.rec_id])
        URLSessionClient().alamofireSend(request) { [weak self] (modela, error) in
            if error == nil {
                self?.deleteGoods(indexPath)
            }else {
                MBProgressHUD.showErrorAdded(message: "删除失败", to: self?.view)
            }
        }
    }
    /*
    /// 删除多个cell
    ///
    /// - Parameter indexPath: [indexPath]
    func requestDeleteGoods(with deleteModels: [CCShopProductList]) {
        var IDArray: [String] = []
        for model in deleteModels {
            IDArray.append(model.ID)
        }
        let data = try? JSONSerialization.data(withJSONObject: IDArray, options: .prettyPrinted)
        let str = String.init(data: data!, encoding: .utf8)
        
        let parameters = ["type": 1, "buycarids": str!] as [String : Any]
        let request = CCOperateBuyCarRequset(parameters: parameters, path: "OperateBuyCar")
        MeetURLSessionClient().send(request, handler: { [unowned self] (datas, error) in
            if error == nil {
                self.deleteGoods(with: deleteModels)
            }else {
                MBProgressHUD.showErrorAdded(message: "修改失败", to: self.view)
            }
        })
    }
    */
    /*
    /// 选中cell进行结算
    ///
    /// - Parameter indexPath: [indexPath]
    func createOrderBuycar(with selectedModels: [CCShopProductList]) {
        var IDArray: [String] = []
        for model in selectedModels {
            IDArray.append(model.ID)
        }
        let data = try? JSONSerialization.data(withJSONObject: IDArray, options: .prettyPrinted)
        let str = String.init(data: data!, encoding: .utf8)
        let parameters = ["userid": ShareUserValue.init().userID, "buycarids": str!] as [String : Any]
        let request = CCClearBuyCarRequset(parameters: parameters, path: "CreateOrderByBuycar")
        MeetURLSessionClient().send(request, handler: { [unowned self] (models, error) in
            if error == nil {
                if models.count > 0 {
                    let confirmVC = CCConfirmOrderViewController()
                    confirmVC.dataArray = models as! [CCMeetOrderModel]
                    self.navigationController?.pushViewController(confirmVC, animated: true)
                    self.selectedCells.removeAll()
                    self.deleteGoods(with: selectedModels)
                    self.updateBarStatus(false)
                    DispatchQueue.global().sync {
                        self.updateDictionary()
                        self.calculatePrice()
                    }
                }
            }else {
                MBProgressHUD.showErrorAdded(message: "请重试..", to: self.view)
            }
        })
    }
     */
}

