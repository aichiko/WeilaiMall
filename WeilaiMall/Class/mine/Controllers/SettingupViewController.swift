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
    
    var cancelLogin: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
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
        
        button.addTarget(self, action: #selector(exit), for: .touchUpInside)
    }
    
    @objc private func exit() {
        
        let alertController = UIAlertController.init(title: "提示", message: "确定要退出登录？", preferredStyle: .alert)
        
        let sureAction = UIAlertAction.init(title: "确定", style: .default) { [weak self] (action) in
            UserDefaults.init().setValue(false, forKey: "isLogin")
            if self?.cancelLogin != nil {
                self?.cancelLogin!()
                self?.navigationController?.popViewController(animated: true)
            }
            
        }
        let cancelAction = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        
        alertController.addAction(sureAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
        
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
            cell?.textLabel?.font = UIFont.CCsetfont(16)
            cell?.accessoryType = .disclosureIndicator
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            
        }else {
            if isLogin {
                self.performSegue(withIdentifier: identifiers[indexPath.row], sender: self)
            }else {
                let loginVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "login")
                self.navigationController?.pushViewController(loginVC, animated: true)
            }
        }
    }
}
