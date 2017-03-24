//
//  MineInfoViewController.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/3/23.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit

class MineInfoViewController: ViewController, CCTableViewProtocol {

    var tableView: UITableView = UITableView(frame: CGRect.zero, style: .grouped)
    
    var model: UserModel!
    
    let titles = ["头像", "真实姓名", "生日", "性别", "邮箱", "手机号"]
    
    var detailTitles: [String] = []
    
    let cellIndentifier = "infoCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        configTableView()
    }
    
    
    func configTableView() {
        self.view.addSubview(tableView)
        tableView.snp.updateConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        let timeZone = TimeZone.current.secondsFromGMT()
        let formatter = DateFormatter.init()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: model.birthday)?.addingTimeInterval(TimeInterval(timeZone))
        
        formatter.dateFormat = "yyyy年MM月dd日"
        let birthday = formatter.string(from: date!)
        
        let sex = model.sex == 1 ?"男":"女"
        
        detailTitles = ["", model.real_name, birthday, sex, model.email, String(model.mobile_phone)]
        
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

extension MineInfoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? 80: 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIndentifier)
        if cell == nil {
            cell = UITableViewCell.init(style: .value1, reuseIdentifier: cellIndentifier)
        }
        cell?.accessoryType = indexPath.row > 3 ? .none : .disclosureIndicator
        cell?.textLabel?.text = titles[indexPath.row]
        cell?.detailTextLabel?.text = detailTitles[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

