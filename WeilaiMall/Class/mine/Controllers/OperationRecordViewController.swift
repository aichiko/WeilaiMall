//
//  OperationRecordViewController.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/3/12.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit
import MBProgressHUD

class OperationCellHeadView: UITableViewHeaderFooterView {
    
    var grayView = UIView()
    
    var timeLabel = UILabel()
    
    var date: Date {
        didSet {
            let formatter = DateFormatter.init()
            formatter.dateFormat = "yyyy年MM月dd日 hh:mm:ss"
            let str = formatter.string(from: date)
            timeLabel.text = str
        }
    }
    
    override init(reuseIdentifier: String?) {
        date = Date()
        super.init(reuseIdentifier: reuseIdentifier)
        
        configSubviews()
    }
    
    private func configSubviews() {
        addSubview(grayView)
        
        grayView.snp.updateConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(15)
        }
        
        grayView.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.00)
        
        grayView.addSubview(timeLabel)
        timeLabel.snp.updateConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.centerY.height.equalToSuperview()
        }
        
        timeLabel.text = "2017年02月25日 09:28:00"
        timeLabel.font = UIFont.CCsetfont(14)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// 操作记录 页面
class OperationRecordViewController: ViewController {

    var tableView = UITableView(frame: CGRect.zero, style: .grouped)
    
    let cellIdentifier = "OperationCell"
    let headIdentifier = "headViewIdentifier"
    
    var parameters: [String: Any] = [:]
    
    var dataArray: [OperationRecordModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        configTableView()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "mine_calander")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(calendarAction(_:)))
        
        prepareData(.refreshData)
    }

    private func configTableView() {
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        tableView.snp.updateConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        tableView.register(UINib.init(nibName: "OperationRecordCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.register(OperationCellHeadView.self, forHeaderFooterViewReuseIdentifier: headIdentifier)
    }
    
    
    private func prepareData(_ style: CCRequestStyle) {
        var page: Int = parameters["p"] as? Int ?? 1
        if style == .refreshData {
            page = 1
            parameters.updateValue(page, forKey: "p")
        }else if style == .moreData {
            page += 1
            parameters.updateValue(page, forKey: "p")
        }
        parameters.updateValue(access_token, forKey: "access_token")
        
        URLSessionClient().alamofireSend(OperationRecordRequest(parameter: parameters), handler: { [weak self] (models, error) in
            if error == nil {
                self?.dataArray = models as! [OperationRecordModel]
                self?.tableView.reloadData()
            }else {
                MBProgressHUD.showErrorAdded(message: error!.info(), to: self?.view)
            }
        })
    }
    
    @objc private func calendarAction(_ item: UIBarButtonItem) {
        
        
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

extension OperationRecordViewController: UITableViewDelegate, UITableViewDataSource {
    @available(iOS 2.0, *)
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: headIdentifier) as? OperationCellHeadView
        let model = dataArray[section]
        view?.date = model.change_time
        return view!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? OperationRecordCell
        cell?.selectionStyle = .none
        cellAttribute(with: cell!, indexPath)
        return cell!
    }
}


extension OperationRecordViewController {
    func cellAttribute(with cell: OperationRecordCell, _ indexPath: IndexPath) {
        let model = dataArray[indexPath.section]
        cell.incomings = model.user_money
        cell.amount = model.highreward
        cell.amountGive = model.payin
        cell.backintergral = model.rebate
        cell.cumulative = model.pay_points
        cell.accountLabel.text = model.change_desc
    }
}
