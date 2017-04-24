//
//  CACalendarCell.swift
//  Calendar_demo
//
//  Created by 24hmb on 2017/2/16.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit

/// 点击的cell 的月份
///
/// - previous: 上个月
/// - current: 当前月份
/// - next: 下个月
enum MonthPosition {
    case previous;
    case current;
    case next;
}


protocol CalendarCalculator {
    var formatter: DateFormatter {get}
    var gregorian: Calendar {get}//公历
    var components: DateComponents {get set}
}

class CACalendarCell: UICollectionViewCell, CalendarCalculator {
    
    internal var components: DateComponents = DateComponents.init()

    
    internal var gregorian: Calendar {
        return Calendar.init(identifier: .gregorian)//公历
    }

    internal var formatter: DateFormatter {
        let formatter = DateFormatter.init()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }

    fileprivate let titleLabel = UILabel(frame: CGRect.zero)
    fileprivate let subtitleLabel = UILabel(frame: CGRect.zero)
    fileprivate let eventLabel = UILabel(frame: CGRect.zero)
    
    let shapeLayer = CAShapeLayer.init()
    
    var currentSection: Int = -1
    
    var title: String? {
        didSet{
            titleLabel.text = title
        }
    }
    
    var subtitle: String? {
        didSet{
            subtitleLabel.text = subtitle
            if oldValue == nil && subtitleLabel.constraints.count==0 {
                titleLabel.snp.makeConstraints({ (make) in
                    make.centerX.equalToSuperview()
                    make.top.greaterThanOrEqualTo(5)
                })
                subtitleLabel.snp.makeConstraints({ (make) in
                    make.centerX.equalToSuperview()
                    make.bottom.lessThanOrEqualTo(-7)
                    make.top.greaterThanOrEqualTo(titleLabel.snp.bottom).offset(0)
                })
            }
        }
    }
    
    var eventNum: Int? {
        didSet{
            eventLabel.isHidden = !(eventNum ?? 0 > 0)
        }
    }
    
    var cellPosition: MonthPosition? {
        didSet{
            if cellPosition == .current {
                titleLabel.textColor = UIColor.black
            }else {
                titleLabel.textColor = UIColor.red
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialization()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialization()
        //fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        if subtitle == nil {
            titleLabel.snp.makeConstraints({ (make) in
                make.center.equalToSuperview()
            })
        }
        ConfigShapeLayer()
    }
    
}

extension CACalendarCell {
    func initialization() {
        self.clipsToBounds = false;
        self.contentView.clipsToBounds = false;
        
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(subtitleLabel)
        self.contentView.addSubview(eventLabel)
        titleLabel.textAlignment = .center
        subtitleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.black
        subtitleLabel.textColor = UIColor.lightGray
        subtitleLabel.font = UIFont.systemFont(ofSize: 12)
        eventLabel.backgroundColor = UIColor.red
        
        eventLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(5)
            make.bottom.equalTo(-2)
        }
        eventLabel.layer.masksToBounds = true
        eventLabel.layer.cornerRadius = 2.5
        eventLabel.isHidden = true
        
        shapeLayer.backgroundColor = UIColor.clear.cgColor
        shapeLayer.borderWidth = 1.0
        shapeLayer.borderColor = UIColor.clear.cgColor
        shapeLayer.opacity = 0;
        self.contentView.layer.insertSublayer(shapeLayer, below: titleLabel.layer)
        
    }
    
    func ConfigShapeLayer() {
        let titleHeight = self.bounds.size.height*5.0/6.0;
        var diameter = self.bounds.size.height*5.0/6.0>self.bounds.size.width ?self.bounds.size.height*5.0/6.0:self.bounds.size.width
        diameter = diameter - (diameter-100/3.0)*0.5//直径
        shapeLayer.frame = CGRect(x: (self.bounds.size.width-diameter)/2, y: (titleHeight-diameter)/2, width: diameter, height: diameter)
        
        let path = UIBezierPath.init(roundedRect: shapeLayer.bounds, cornerRadius: diameter*0.5).cgPath
        shapeLayer.path = path
        shapeLayer.fillColor = CCOrangeColor.cgColor
        //shapeLayer.strokeColor = UIColor.red.cgColor
        
    }
    
    /// 点击后的显示动画
    public func cellPerformSelected() {
        shapeLayer.opacity = 1;
        
        let group = CAAnimationGroup.init()
        let zoomOut = CABasicAnimation.init(keyPath: "transform.scale")
        zoomOut.fromValue = 0.3
        zoomOut.toValue = 1.2
        zoomOut.duration = 0.2*0.75
        let zoomIn = CABasicAnimation.init(keyPath: "transform.scale")
        zoomIn.fromValue = 1.2
        zoomIn.toValue = 1.0
        zoomIn.beginTime = 0.2*0.75
        zoomIn.duration = 0.2*0.25
        
        group.duration = 0.2
        group.animations = [zoomOut, zoomIn]
        shapeLayer.add(group, forKey: "bounces")
    }
    
    public func shapeLayerUpdate() {
        if !self.isSelected {
            shapeLayer.opacity = 0
        }
    }
}

extension CACalendarCell {
    public func cellDate(_ indexPath: IndexPath) {
        //self.title = String(indexPath.section)+"-"+String(indexPath.row)
        //self.eventNum = indexPath.item%3 - 1
        
        
        var month: Date?
        currentSection = indexPath.section
        var minimumDate = formatter.date(from: "1970-01-01")
        var maximumDate = formatter.date(from: "2099-12-31")
        //加入当前时区
        let zone = TimeZone.current
        let interval = zone.secondsFromGMT(for: Date())
        minimumDate?.addTimeInterval(TimeInterval(interval))
        maximumDate?.addTimeInterval(TimeInterval(interval))
        components = gregorian.dateComponents([.year, .month, .day, .hour], from: minimumDate!)
        components.day = 1
        month = gregorian.date(byAdding: .month, value: indexPath.section, to: gregorian.date(from: components)!)
        
        
        //加入分区数后的日期
        //    Sunday:1, Monday:2, Tuesday:3, Wednesday:4,Thursday: 5, Friday:6, Saturday:7
        let currentWeekday = gregorian.component(.weekday, from: month!)//得出当前日期的星期数
        let day = gregorian.date(byAdding: .day, value: indexPath.row, to: monthHead(currentWeekday, month)!)
        
        let start = "1970-01-01".index("1970-01-".endIndex, offsetBy: 1)
        let end = "1970-01-01".endIndex
        self.title = (day?.description)!.substring(with: start..<end)
        
        let lenght = (gregorian.range(of: .day, in: .month, for: month!)?.upperBound)! - (gregorian.range(of: .day, in: .month, for: month!)?.lowerBound)!
        var index = ((currentWeekday - gregorian.firstWeekday) + 7) % 7
        if index == 0 {
            index = 7
        }
        //print(day)
        self.cellPosition = cellPostion(indexPath, index, lenght+index)
    }
    
    func realIndexPath(_ indexPath: IndexPath, _ position: MonthPosition) -> IndexPath? {
        var section: Int
        var item: Int
        var minimumDate = formatter.date(from: "1970-01-01")
        //加入当前时区
        let zone = TimeZone.current
        let interval = zone.secondsFromGMT(for: Date())
        minimumDate?.addTimeInterval(TimeInterval(interval))
        let month = gregorian.date(byAdding: .month, value: indexPath.section, to: minimumDate!)
        let currentWeekday = gregorian.component(.weekday, from: month!)
        let head = monthHead(currentWeekday, month!)
        //indexPath 位置当前的时间
        let date = gregorian.date(byAdding: .day, value: indexPath.row, to: head!)
        
        guard (date != nil) else {
            return nil
        }
        
        //下面将算出将要滑动到的位置
        section = gregorian.dateComponents([.month], from: minimumDate!, to: date!).month!
        
        let realmonth = gregorian.date(byAdding: .month, value: section, to: minimumDate!)
        let realcurrentWeekday = gregorian.component(.weekday, from: realmonth!)
        let realHead = monthHead(realcurrentWeekday, realmonth!)
        
        item = gregorian.dateComponents([.day], from: realHead!, to: date!).day!
        print(IndexPath.init(item: item, section: section))
        return IndexPath.init(item: item, section: section)
        
    }
    
    
    private func cellPostion(_ indexPath: IndexPath ,_ start: Int, _ end: Int) -> MonthPosition {
        if indexPath.row < start {
            return .previous
        }else if indexPath.row >= start && indexPath.row < end {
            return .current
        }
        return .next
    }
    
    ///根据每个月 1 号的 currentWeekday，算出这个section 是以那个日期进行开头的
    private func monthHead(_ currentWeekday: Int, _ month: Date?) -> Date? {
        var index = ((currentWeekday - gregorian.firstWeekday) + 7) % 7
        if index == 0 {
            index = 7
        }
        return gregorian.date(byAdding: .day, value: -index, to: month!)
    }
}
