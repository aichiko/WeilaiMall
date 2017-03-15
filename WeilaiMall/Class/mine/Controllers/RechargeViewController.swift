//
//  RechargeViewController.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/3/15.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit

/// 充值 页面
class RechargeViewController: ViewController {

    var tableView = UITableView.init(frame: CGRect.zero, style: .grouped)
    let cellIdentifier = "RechargeCell"
    let button: CCSureButton = CCSureButton.init("确认充值")
    
    let titles: [String] = ["充值金额", "支付方式"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addBackItem()
        
        configTableView()
    }
    
    private func configTableView() {
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        tableView.snp.updateConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        tableView.addSubview(button)
        
        button.snp.updateConstraints { (make) in
            make.top.equalTo(150)
            make.centerX.equalToSuperview()
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(44)
        }
        
        button.addTarget(self, action: #selector(rechargeAction(_:)), for: .touchUpInside)
        
    }
    
    @objc private func rechargeAction(_ button: CCSureButton) {
        print("充值！！！")
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

extension RechargeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell.init(style: .value1, reuseIdentifier: cellIdentifier)
            cell?.accessoryType = indexPath.row == 0 ?.none:.disclosureIndicator
        }
        cell?.textLabel?.text = titles[indexPath.row]
        cell?.detailTextLabel?.text = indexPath.row == 0 ?"3000":"支付宝"
        cell?.selectionStyle = .none
        return cell!
    }
}
