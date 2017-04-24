//
//  HomeSearchViewController.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/3/20.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit

class HomeSearchViewController: ViewController {

    lazy var searchBar = UISearchBar.init()
    
    var path = ""
    
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

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "search_result" {
            let controller = segue.destination as! SearchResultViewController
            searchBar.delegate = nil
            searchBar.delegate = controller
            controller.searchKey = searchBar.text
            controller.path = path
            controller.resetDelegate = {
                [weak self] in
                guard self != nil else {
                    return
                }
                self?.searchBar.delegate = self
            }
        }
    }
}

extension HomeSearchViewController {
    func navigationAttribute() {
        
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
        self.dismiss(animated: false, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.performSegue(withIdentifier: "search_result", sender: self)
    }
}
