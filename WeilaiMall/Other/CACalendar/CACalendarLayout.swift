//
//  CACalendarLayout.swift
//  Calendar_demo
//
//  Created by 24hmb on 2017/2/15.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit

let columnCount: Int = 7
let minSpace = CGFloat(10)//cell之间最小的间距
var cellWidth: CGFloat = 40
//还需要计算不同高度的时候cell之间的间隙
let cellInsets = UIEdgeInsetsMake(5, 0, 5, 0)

class CACalendarLayout: UICollectionViewLayout {
    
    var contentSize: CGSize?
    var cellSize: CGSize = CGSize.zero
    
    var attributesArray = [UICollectionViewLayoutAttributes]()
    
    var lefts = [CGFloat]()//item point—x
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        attributesArray.removeAll()
        
        contentSize = CGSize(width: (self.collectionView?.bounds.width)!*CGFloat((self.collectionView?.numberOfSections)!), height: (self.collectionView?.bounds.height)!)
        cellSize = estimatedItemSize()
        
        super.prepare()
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        if !rect.intersects(CGRect.init(x: 0, y: 0, width: (contentSize?.width)!, height: (contentSize?.height)!)) {return nil}
        //重叠的大小
        let intersectsRect = rect.intersection(CGRect.init(x: 0, y: 0, width: (contentSize?.width)!, height: (contentSize?.height)!))
        attributesArray.removeAll()
        let wholeSections = Int(intersectsRect.width/(self.collectionView?.bounds.width)!)
        var numberOfColumns = wholeSections*7//intersectsRect 中包含的纵列的总数
        let numberOfRows = 6//每一个纵列有6个
        let startSection = Int(intersectsRect.origin.x/(self.collectionView?.bounds.width)!)
        
        let leftColumn = (intersectsRect.minX).truncatingRemainder(dividingBy: ((self.collectionView?.bounds.width)!))
        let leftCount = leftColumn/(cellSize.width+cellInsets.left+cellInsets.right)
        
        let startColumn = startSection*7 + Int(floor(leftCount))
        
        let rightColumn = intersectsRect.maxX.truncatingRemainder(dividingBy: ((self.collectionView?.bounds.width)!))
        let rightCount = rightColumn/(cellSize.width+cellInsets.left+cellInsets.right)
        
        numberOfColumns += (7-Int(floor(leftCount)));
        numberOfColumns += Int(ceil(rightCount));
        
        if rightCount > leftCount {
            numberOfColumns -= 7
        }
        let endColumn = startColumn + numberOfColumns - 1;
        
        for column in startColumn...endColumn {
            for row in 0 ..< numberOfRows {
                let section = column / 7;
                let item = (column % 7) + (row * 7);
                let indexPath = IndexPath.init(item: item, section: section)
                let attributes = layoutAttributesForItem(at: indexPath)
                attributesArray.append(attributes!)
            }
        }
        return attributesArray
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        let item = indexPath.item
        let section = CGFloat(indexPath.section)
        let width = (self.collectionView?.bounds.width)!
        let point_x = width*section + cellInsets.left + (cellSize.width+cellInsets.left+cellInsets.right) * CGFloat(item%columnCount)
        let point_y = cellInsets.top + (cellSize.height+cellInsets.top+cellInsets.bottom) * CGFloat(item/columnCount)
        attributes.frame = CGRect(x: point_x, y: point_y, width: cellSize.width, height: cellSize.height)
        return attributes
    }
    
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if elementKind == UICollectionElementKindSectionHeader {
            let attributes = UICollectionViewLayoutAttributes.init(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, with: indexPath)
            attributes.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            return attributes
        }
        return nil
    }
    
    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return nil
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: (self.collectionView?.bounds.width)!*CGFloat((self.collectionView?.numberOfSections)!), height: (self.collectionView?.bounds.height)!)
    }
}

extension UICollectionViewLayout {
    //通过collectionView的大小来算出cell的预计大小
    public func estimatedItemSize() -> CGSize {
        let width = CGFloat((self.collectionView?.frame.width)!/7) - cellInsets.left - cellInsets.right
        let  height = CGFloat((self.collectionView?.frame.height)!/6.0) - cellInsets.top - cellInsets.bottom
        print("width ==\(width) height ==\(height)")
        return CGSize(width: width, height: height)
    }
    
}
