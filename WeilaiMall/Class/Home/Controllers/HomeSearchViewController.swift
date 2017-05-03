//
//  HomeSearchViewController.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/3/20.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD

class HotSearchHead: UICollectionReusableView {
    var titleLabel: UILabel = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialization()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialization()
        //fatalError("init(coder:) has not been implemented")
    }
    
    private func initialization() {
        self.addSubview(titleLabel)
        titleLabel.textColor = CCTitleTextColor
        titleLabel.text = "热门搜索"
        titleLabel.font = UIFont.CCsetfont(14)
        titleLabel.snp.updateConstraints { (make) in
            make.left.equalTo(10)
            make.centerY.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        //initialization()
    }
}


class HotSearchCell: UICollectionViewCell {
    
    var titleLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialization()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialization()
        //fatalError("init(coder:) has not been implemented")
    }
    
    private func initialization() {
        self.contentView.addSubview(titleLabel)
        titleLabel.textColor = CCTitleTextColor
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.CCsetfont(13)
        titleLabel.snp.updateConstraints { (make) in
            make.center.equalToSuperview()
        }
        //加上圆角
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 4
    }
}

class HomeSearchViewController: ViewController {

    struct HotSearchRequest: CCRequest {
        
        let path: String = hotsearch
        
        var parameter: [String: Any] = [:]
        typealias Response = String
        
        func JSONParse(value: JSON) -> [String?]? {
            let arr = value["data"].arrayValue
            var arr1: [String] = []
            for item in arr {
                arr1.append(item["keyword"].stringValue)
            }
            return arr1
        }
    }

    
    
    fileprivate let cellIdentifier = "packagesCell"
    fileprivate let headIdentifier = "packagesHead"
    fileprivate let cellColor = UIColor.colorWithString("#F5F5F5")
    
    lazy var searchBar = UISearchBar.init()
    
    var path = ""
    
    lazy var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    /// 每个cell的宽度 数组
    var widths: [CGFloat] = []
    
    /// 每个cell显示的文字
    var titles: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationAttribute()
        
        configCollectionView()
        
        prepareData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func navigationAttribute() {
        
        searchBar.showsCancelButton = true
        searchBar.delegate = self
        
        self.navigationItem.titleView = searchBar
        searchBar.becomeFirstResponder()
    }
    
    func configCollectionView() {
        self.view.addSubview(collectionView)
        collectionView.backgroundColor = CCbackgroundColor
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = false
        collectionView.register(HotSearchCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.register(HotSearchHead.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headIdentifier)
        collectionView.snp.updateConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func prepareData() {
        let request = HotSearchRequest()
        URLSessionClient().alamofireSend(request) { [weak self] (models, error) in
            if error == nil {
                self?.titles = models as! [String]
                self?.widths = (self?.cellWidths(titles: (self?.titles)!))!
                self?.collectionView.reloadData()
            }else {
                MBProgressHUD.showErrorAdded(message: (error?.getInfo())!, to: self?.view)
            }
        }
    }
    
    
    /// 根据套餐的长度 计算 每个cell的宽度
    ///
    /// - Returns: cell 宽度的数组
    fileprivate func cellWidths(titles: [String]) -> [CGFloat] {
        widths = []
        for title in titles {
            var width: CGFloat = 0
            let str = NSString.init(string: title)
            let attrs = [NSFontAttributeName: UIFont.CCsetfont(13)!]
            let strWidth = str.boundingRect(with: CGSize(width: 0, height: 40), options: .usesFontLeading, attributes: attrs, context: nil).width
            width = strWidth+20
            /*
             if (model.Name?.characters.count)! <= 2 {
             width = 50
             } else if (model.Name?.characters.count)! <= 5 && (model.Name?.characters.count)! > 2 {
             width = 90
             } else {
             width = 130
             }
             */
            widths.append(width)
        }
        return widths
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
            searchBar.resignFirstResponder()
            controller.path = path
            controller.resetSearchKey = {
                [unowned self] text in
                self.searchBar.becomeFirstResponder()
                self.searchBar.text = text
            }
        }
    }
}

extension HomeSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 40)
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(10, 15, 10, 15)
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: widths[indexPath.item], height: 30)
    }
    
    @available(iOS 6.0, *)
    internal func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headIdentifier, for: indexPath)
        return headView
    }
    
    internal func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return widths.count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! HotSearchCell
        cell.backgroundColor = cellColor
        cell.titleLabel.text = titles[indexPath.item]
        return cell
    }
    
    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? HotSearchCell
        cell?.isSelected = true
        cell?.titleLabel.textColor = UIColor.white
        cell?.backgroundColor = CCOrangeColor
        searchBar.text = titles[indexPath.item]
        self.performSegue(withIdentifier: "search_result", sender: self)
    }
    
    internal func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? HotSearchCell
        cell?.titleLabel.textColor = CCTitleTextColor
        cell?.backgroundColor = cellColor
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
