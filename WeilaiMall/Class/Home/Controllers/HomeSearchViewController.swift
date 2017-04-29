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
            controller.searchKey = searchBar.text
            controller.path = path
            controller.resetSearchKey = {
                [unowned self] text in
                self.searchBar.becomeFirstResponder()
                self.searchBar.text = text
            }
        }
    }
}

extension HomeSearchViewController {
    func navigationAttribute() {
        
        searchBar.showsCancelButton = true
        searchBar.delegate = self
        
        self.navigationItem.titleView = searchBar
        searchBar.becomeFirstResponder()
    }
}

extension HomeSearchViewController: UISearchBarDelegate {
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.performSegue(withIdentifier: "search_result", sender: self)
    }
}
