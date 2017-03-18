//
//  MineViewController.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/2/26.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit

enum PushIdentifier: String {
    case transfer = "transfer"
    case clearing = "clearing"
    case myorder = "myorder"
    case record = "record"
    case register = "invitedRegister"
    case Recharge = "Recharge"
    case settingup = "settingup"
    case about = "about"
}


let width = UIScreen.main.bounds.width/4

let CCbackgroundColor = UIColor(red:0.94, green:0.95, blue:0.96, alpha:1.00)

private let cellIdentifier = "MineCollectionViewCell"

class MineViewController: ViewController {

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    var titles = ["转账", "结算支付", "订单中心", "操作记录", "邀请注册", "充值", "设置", "关于"]
    var imageTitles = ["transfer_icon", "account_icon", "order_icon", "record_icon", "inviteRegister_icon", "recharge_icon", "setup_icon", "about_icon"]
    
    var identifiers = ["transfer", "clearing", "myorder", "record", "invitedRegister", "Recharge", "settingup", "about"]
    
    var headView = MineHeadView()
    var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true
        configSubviews()
        
        let dic: [String: Any] = ["mobile_phone": "15172386472", "type": 1,]
        print(String.MD5(with: dic))
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

extension MineViewController {
    fileprivate func configSubviews() {
        self.view.addSubview(headView)
        self.view.addSubview(collectionView)
        headView.style = .notlogin
        headView.snp.updateConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(230)
        }
        
        headView.click = {
            [unowned self] in
            if self.headView.style == .notlogin {
                let loginVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "login")
                self.navigationController?.pushViewController(loginVC, animated: true)
            }
        }
        
        collectionView.snp.updateConstraints { (make) in
            make.top.equalTo(self.headView.snp.bottom)
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
        collectionView.backgroundColor = CCbackgroundColor
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib.init(nibName: "MineCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
    }
}

extension MineViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @available(iOS 6.0, *)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: width-1, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? MineCollectionViewCell
        cell?.backgroundColor = UIColor.white
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        cell?.selectedBackgroundView = view
        cell?.title = titles[indexPath.item]
        cell?.imageView.image = UIImage.init(named: imageTitles[indexPath.item])
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
        collectionView.deselectItem(at: indexPath, animated: true)
        self.performSegue(withIdentifier: identifiers[indexPath.item], sender: self)
    }
    
}
