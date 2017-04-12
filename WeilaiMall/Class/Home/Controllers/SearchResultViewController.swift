//
//  SearchResultViewController.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/3/21.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit

class SearchResultViewController: ViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //print("viewWillAppear")
        navigationBarShow(with: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //print("viewWillDisappear")
        navigationBarShow(with: false)
    }
    
    var resetDelegate: (() -> Void)?
    
    var searchKey: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "back_icon")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(resultBackAction(_:)))
    }
    
    
    @objc private func resultBackAction(_ item: UIBarButtonItem) {
        _ = self.navigationController?.popViewController(animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        if resetDelegate != nil {
            resetDelegate!()
        }
        print("\(self) deinit ")
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

extension SearchResultViewController: UISearchBarDelegate {
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if resetDelegate != nil {
            resetDelegate!()
        }
        self.dismiss(animated: false, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //self.performSegue(withIdentifier: "search_result", sender: self)
        print(searchBar)
    }
}


extension SearchResultViewController {
    
    /// 根据 appear 来改变 navigationBar 的显示风格
    ///
    /// - Parameter appear: 是否为显示  true为显示，false为消失
    func navigationBarShow(with appear: Bool) {
        let leftpadding = appear ?60:10
        for view in (navigationController?.navigationBar.subviews)! {
            if view is UISearchBar, let searchbar = view as? UISearchBar {
                searchbar.snp.updateConstraints({ (make) in
                    make.left.equalTo(leftpadding)
                })
            }
        }
    }
}
