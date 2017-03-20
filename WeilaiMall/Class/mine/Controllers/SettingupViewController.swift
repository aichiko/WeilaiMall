//
//  SettingupViewController.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/3/8.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit

class SettingupViewController: ViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let titles = ["修改登录密码", "修改支付密码", "清除缓存"]
    
    let identifiers = ["loginpassword", "paypassword", ""]
    
    var button = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addBackItem()
        
        addButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func addButton() {
        self.view.addSubview(button)
        
        button.snp.updateConstraints { (make) in
            make.centerX.equalToSuperview()
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(44)
            make.top.equalTo(250)
        }
        
        button.backgroundColor = CCOrangeColor
        button.setTitle("退出登录", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor.lightGray, for: .highlighted)
        button.titleLabel?.font = UIFont.CCsetfont(14)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 4
        button.isHidden = !isLogin
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

extension SettingupViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
            cell?.textLabel?.text = titles[indexPath.row]
            cell?.accessoryType = .disclosureIndicator
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            
        }else {
            self.performSegue(withIdentifier: identifiers[indexPath.row], sender: self)
        }
    }
}
