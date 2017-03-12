//
//  OperationRecordViewController.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/3/12.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit


class OperationCellHeadView: UITableViewHeaderFooterView {
    
    var grayView = UIView()
    
    var timeLabel = UILabel()
    
    
    override init(reuseIdentifier: String?) {
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
        
        
        let formatter = DateFormatter.init()
        formatter.dateFormat = "yyyy年MM月dd日 hh:mm:ss"
        
        let date = formatter.date(from: "2017年02月25日 09:28:00")
        let interval = TimeZone.current.secondsFromGMT(for: date!)
        let newDate = date?.addingTimeInterval(TimeInterval(interval))
        print(newDate!)
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addBackItem()
        
        configTableView()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "mine_calander")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(calendarAction(_:)))
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
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: headIdentifier)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
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
        cell.amount = 20000
        cell.amountGive = 200
        cell.backintergral = 2000
        cell.cumulative = -200
        cell.incomings = -200
    }
}
