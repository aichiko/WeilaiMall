//
//  CACalendar.swift
//  Calendar_demo
//
//  Created by 24hmb on 2017/2/15.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit

private let cellIdentifier = "cell"

class CACalendar: UIView, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, CalendarCalculator {

    var headLabel = UILabel()
    
    let headView = CACalendarWeekdayView()
    
    var contentView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout.init())
    //var months: Array = [Any]()
    
    internal var components: DateComponents = DateComponents.init()
    
    internal var gregorian: Calendar {
        return Calendar.init(identifier: .gregorian)//公历
    }
    
    internal var formatter: DateFormatter {
        let formatter = DateFormatter.init()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    
    var selectedIndexPath: IndexPath?
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
    
    @available(iOS 6.0, *)
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 42
    }

    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    @available(iOS 6.0, *)
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionNumbers()
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CACalendarCell
//        cell.backgroundColor = UIColor.orange
        cell.cellDate(indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
        var cell = collectionView.cellForItem(at: indexPath) as! CACalendarCell
        //print(cell.cellPosition)
        if cell.cellPosition == .current {
            cell = collectionView.cellForItem(at: indexPath) as! CACalendarCell
            cell.isSelected = true
            cell.cellPerformSelected()
            selectedIndexPath = indexPath
        }else {
            let cellIndexPath = cell.realIndexPath(indexPath, cell.cellPosition!)
            collectionView.selectItem(at: IndexPath.init(item: 0, section: (cellIndexPath?.section)!), animated: true, scrollPosition: .left)
            if (cellIndexPath != nil) {
                let cell = contentView.cellForItem(at: cellIndexPath!) as? CACalendarCell
                cell?.isSelected = true
                cell?.cellPerformSelected()
                selectedIndexPath = cellIndexPath
            }
            headLabel.text = currentDate((cellIndexPath?.section)!)
        }
        for item in 0..<42 {
            let indexPath: IndexPath = IndexPath.init(item: item, section: indexPath.section)
            if  indexPath != selectedIndexPath! {
                let cell = collectionView.cellForItem(at: indexPath)
                cell?.isSelected = false
                (cell as! CACalendarCell).shapeLayerUpdate()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? CACalendarCell
        cell?.isSelected = false
        cell?.shapeLayerUpdate()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if selectedIndexPath != nil && indexPath == selectedIndexPath!  {
            cell.isSelected = true
            (cell as! CACalendarCell).cellPerformSelected()
        }else {
            cell.isSelected = false
            (cell as! CACalendarCell).shapeLayerUpdate()
        }
    }
    
    
    @available(iOS 2.0, *)
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("滑动结束！！！")
        let index = Int(scrollView.contentOffset.x/scrollView.bounds.width)
        headLabel.text = currentDate(index)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configCollectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        //super.init(coder: aDecoder)
        super.init(coder: aDecoder)
        configCollectionView()
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configCollectionView() {
        self.addSubview(contentView)
        self.addSubview(headView)
        
        headView.snp.makeConstraints { (make) in
            make.top.equalTo(30)
            make.left.right.equalTo(0)
            make.height.equalTo(30)
            make.width.equalToSuperview()
        }
        contentView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(60)
        }
        self.addSubview(headLabel)
        headLabel.textAlignment = .center
        headLabel.font = UIFont.systemFont(ofSize: 18)
        headLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(headView.snp.top).offset(0)
        }
        headLabel.text = currentDate(-1)
        
        loadView(rect: self.bounds)
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        scrollCurrentDate()
    }
}

extension CACalendar {
    func loadView(rect: CGRect) {
        let layout = CACalendarLayout()
        contentView.collectionViewLayout = layout
        contentView.isPagingEnabled = true
        contentView.showsVerticalScrollIndicator = false
        contentView.showsHorizontalScrollIndicator = false
        contentView.allowsMultipleSelection = false
        contentView.clipsToBounds = true
        contentView.delegate = self
        contentView.dataSource = self
        contentView.backgroundColor = UIColor.clear
        contentView.register(CACalendarCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
        formatter.dateFormat = "yyyy-MM-dd"
    }
    
    func sectionNumbers() -> Int {
        var minimumDate = formatter.date(from: "1970-01-01")
        var maximumDate = formatter.date(from: "2099-12-31")
        //加入当前时区
        let zone = TimeZone.current
        let interval = zone.secondsFromGMT(for: Date())
        minimumDate?.addTimeInterval(TimeInterval(interval))
        maximumDate?.addTimeInterval(TimeInterval(interval))
        
        let months = gregorian.dateComponents([.month], from: minimumDate!, to: maximumDate!).month!+1
        return months
    }
    
    
    func currentDate(_ section: Int) -> String? {
        var minimumDate = formatter.date(from: "1970-01-01")
        //加入当前时区
        let zone = TimeZone.current
        let interval = zone.secondsFromGMT(for: Date())
        minimumDate?.addTimeInterval(TimeInterval(interval))
        if section == -1 {
            //返回当前的时间 月份
            let currentDate = Date().addingTimeInterval(TimeInterval(interval))
            
            return currentDate.description.substring(to: "1970-01".endIndex)
        }else {
            let sectionDate = gregorian.date(byAdding: .month, value: section, to: minimumDate!)
            return sectionDate?.description.substring(to: "1970-01".endIndex)
        }
    }
    
    func scrollCurrentDate() {
        var minimumDate = formatter.date(from: "1970-01-01")
        //加入当前时区
        let zone = TimeZone.current
        let interval = zone.secondsFromGMT(for: Date())
        minimumDate?.addTimeInterval(TimeInterval(interval))
        
        let currentDate = Date().addingTimeInterval(TimeInterval(interval))
        let monthCount = gregorian.dateComponents([.month], from: minimumDate!, to: currentDate).month
        contentView.setContentOffset(CGPoint.init(x: CGFloat(monthCount!)*self.bounds.width, y: 0), animated: false)
    }
}
