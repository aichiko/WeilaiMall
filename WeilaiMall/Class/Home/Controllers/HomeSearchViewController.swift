//
//  HomeSearchViewController.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/3/20.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit

class HomeSearchViewController: ViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationAttribute()
        
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

extension HomeSearchViewController {
    func navigationAttribute() {
        let searchBar = UISearchBar.init()
        searchBar.showsCancelButton = true
        searchBar.delegate = self
        navigationController?.navigationBar.addSubview(searchBar)
        searchBar.snp.updateConstraints { (make) in
            make.right.top.bottom.equalToSuperview()
            make.left.equalTo(20)
        }
        searchBar.becomeFirstResponder()
    }
}

extension HomeSearchViewController: UISearchBarDelegate {
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
}
