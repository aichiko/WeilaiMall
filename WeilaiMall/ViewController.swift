//
//  ViewController.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/2/23.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


extension ViewController {
    func addBackItem() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "back_icon")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(backAction(_:)))
    }
    
    @objc private func backAction(_ item: UIBarButtonItem) {
        _ = self.navigationController?.popViewController(animated: true)
    }
}
