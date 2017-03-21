//
//  CCShoppingCar+UITableView.swift
//  24HMB
//
//  Created by 24hmb on 2017/3/4.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import Foundation
import UIKit

// MARK: - cellAttribute
extension ShoppingCartViewController {
    func cellAttribute(_ cell: CCShoppingCarCell, _ indexPath: IndexPath) {
        
        
        
        if numberDictionary[indexPath] != nil {
            let value = numberDictionary[indexPath]
            cell.textFieldText = value
        }else {
            cell.textFieldText = "1"
            numberDictionary[indexPath] = "1"
        }
        
        
        func cellStatus(_ cellButtonStatus: inout [IndexPath: Bool]) {
            if cellButtonStatus[indexPath] != nil {
                let value = cellButtonStatus[indexPath]
                cell.selectButton.isSelected = value!
            }else {
                cell.selectButton.isSelected = false
                cellButtonStatus[indexPath] = false
            }
        }
        
        if self.shoppingBar.style == .normal {
            cellStatus(&self.cellButtonStatus)
        }else {
            cellStatus(&self.deleteCellButtonStatus)
        }
        //改变商品 的个数
        cell.changeText = {
            [unowned self] text in
            print("text === \(text)")
            self.numberDictionary[indexPath] = text
            if let value = self.selectedCells[indexPath] {
                let number = Int(text)!
                let price = value.1
                self.selectedCells[indexPath] = (number, price)
            }
            self.updateDictionary()
            self.calculatePrice()
        }
        //button的点击
        cell.buttonAction = {
            [unowned self] button in
            print(indexPath)
            
            func cellShow(_ cellStatus: inout [IndexPath: Bool], _ headStatus: inout [Int: Bool]) {
                if let deleteRow = self.deleteOne?.row, indexPath.row > deleteRow {
                    let realIndexPath = IndexPath(row: indexPath.row-1, section: indexPath.section)
                    cellStatus[realIndexPath] = button.isSelected
                }else {
                    cellStatus[indexPath] = button.isSelected
                }
                let section = indexPath.section
                var count = 0
                let rowNum = self.tableView.numberOfRows(inSection: indexPath.section)
                for row in 0..<rowNum {
                    let path = IndexPath(row: row, section: section)
                    if let value = cellStatus[path], value == true {
                        count += 1
                    }
                }
                //说明分区的cell全部为选中状态
                if rowNum == count {
                    let headView = self.tableView.headerView(forSection: section) as! CCShoppingCarHeadView
                    headView.button.isSelected = true
                    headStatus[section] = true
                }else {
                    let headView = self.tableView.headerView(forSection: section) as! CCShoppingCarHeadView
                    headView.button.isSelected = false
                    headStatus[section] = false
                }
            }
            if self.shoppingBar.style == .normal {
                cellShow(&self.cellButtonStatus, &self.headButtonStatus)
            }else {
                cellShow(&self.deleteCellButtonStatus, &self.deleteHeadButtonStatus)
            }
            //更新shoppingBar 的状态
            self.updateBarStatus(button.isSelected)
            DispatchQueue.global().sync {
                self.updateDictionary()
                self.calculatePrice()
            }
        }
    }
}

// MARK: - headAttribute & updateBar
extension ShoppingCartViewController {
    
    func headAttribute(_ headView: CCShoppingCarHeadView, _ section: Int) {
        
        func headStatus(_ headButtonStatus: inout [Int: Bool]) {
            if headButtonStatus[section] != nil {
                let value = headButtonStatus[section]
                headView.button.isSelected = value!
            }else {
                headView.button.isSelected = false
                headButtonStatus[section] = false
            }
        }
        if shoppingBar.style == .normal {
            headStatus(&headButtonStatus)
        }else {
            headStatus(&deleteHeadButtonStatus)
        }
        
        headView.buttonAction = {
            [unowned self] button in
            
            func headShow(_ cellButtonStatus: inout [IndexPath: Bool]) {
                
                let rowNum = self.tableView.numberOfRows(inSection: section)
                for row in 0..<rowNum {
                    let indexPath = IndexPath(row: row, section: section)
                    cellButtonStatus[indexPath] = button.isSelected
                    let cell = self.tableView.cellForRow(at: indexPath) as! CCShoppingCarCell
                    cell.selectButton.isSelected = button.isSelected
                }
            }
            if self.shoppingBar.style == .normal {
                headShow(&self.cellButtonStatus)
                self.headButtonStatus[section] = button.isSelected
            }else {
                headShow(&self.deleteCellButtonStatus)
                self.deleteHeadButtonStatus[section] = button.isSelected
            }
            //更新shoppingBar 的状态
            self.updateBarStatus(button.isSelected)
            DispatchQueue.global().sync {
                self.updateDictionary()
                self.calculatePrice()
            }
            print(section)
        }
    }
    
    /// 全选所有商品
    ///
    /// - Parameter button: button
    @objc func BarButtonAction(_ button: UIButton) {
        button.isSelected = !button.isSelected
        let value = button.isSelected
        
        func barShow(_ headButtonStatus: inout [Int: Bool], _ cellButtonStatus: inout [IndexPath: Bool]) {
            let sectionNum = self.tableView.numberOfSections
            for section in 0..<sectionNum {
                headButtonStatus[section] = value
                for row in 0..<self.tableView.numberOfRows(inSection: section) {
                    let indexPath = IndexPath(row: row, section: section)
                    cellButtonStatus[indexPath] = value
                }
            }
        }
        
        if shoppingBar.style == .normal {
            barShow(&headButtonStatus, &cellButtonStatus)
        }else {
            barShow(&deleteHeadButtonStatus, &deleteCellButtonStatus)
        }
        tableView.reloadData()
        DispatchQueue.global().sync {
            self.updateDictionary()
            self.calculatePrice()
        }
    }
    /// 更新shoppingBar 的状态
    func updateBarStatus(_ buttonSelected: Bool) {
        func barShow(headStatus: inout [Int: Bool]) {
            if buttonSelected == true {
                var sectionCount = 0
                let sectionNum = tableView.numberOfSections
                for section in 0..<sectionNum {
                    if let value = headStatus[section], value == true {
                        sectionCount += 1
                    }
                }
                if sectionCount == sectionNum {
                    self.shoppingBar.selectButton.isSelected = true
                }else {
                    self.shoppingBar.selectButton.isSelected = false
                }
            }else {
                self.shoppingBar.selectButton.isSelected = false
            }
        }
        
        if shoppingBar.style == .normal {
            barShow(headStatus: &headButtonStatus)
        }else {
            // 删除模式
            barShow(headStatus: &deleteHeadButtonStatus)
        }
    }
}


// MARK: - 通过cell的滑动单个删除
extension ShoppingCartViewController {
    
    /// 通过cell的滑动单个删除
    ///
    /// - Parameter indexPath: cell的indexPath
    func deleteGoods(_ indexPath: IndexPath) {
        print("delete === \(indexPath)")
        let deleteArr = dataArray[indexPath.section]
        deleteOne = indexPath
        dataArray[indexPath.section].remove(at: indexPath.row)
        
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
        //改变 单个cell的状态
        func deleteCell(_ cellStatus: inout [IndexPath: Bool]) {
            var keys: [IndexPath] = []
            var values: [Bool?] = []
            for i in indexPath.row..<deleteArr.count {
                let newIndexPath = IndexPath(row: i, section: indexPath.section)
                keys.append(newIndexPath)
                values.append(cellStatus[newIndexPath])
            }
            cellStatus.removeValue(forKey: keys.last!)
            keys.removeLast()
            for key in keys {
                let j = keys.index(of: key)!
                cellStatus[key] = values[j+1]
            }
            
        }
        deleteCell(&cellButtonStatus)
        deleteCell(&deleteCellButtonStatus)
        // 如果分区的cell个数为 0 ，则删除整个分区
        var deleteSection: Int?
        for i in 0..<dataArray.count {
            let arr = dataArray[i]
            if arr.count == 0 {
                deleteSection = i
            }
        }
        func deleteCurrentSection(_ cellStatus: inout [IndexPath: Bool], _ headStatus: inout [Int: Bool], _ section: Int) {
            //移除 整个分区
            //给分区字典重新赋值
            var keys: [Int] = []
            var values: [Bool?] = []
            for i in section..<tableView.numberOfSections {
                keys.append(i)
                values.append(headStatus[i])
            }
            keys.removeLast()
            headStatus.removeValue(forKey: section)
            for key in keys {
                let j = keys.index(of: key)!
                headStatus[key] = values[j+1]
            }
            for i in section+1..<tableView.numberOfSections {
                for row in 0..<tableView.numberOfRows(inSection: i) {
                    let path = IndexPath(row: row, section: i)
                    let newPath = IndexPath(row: row, section: i-1)
                    cellStatus[newPath] = cellStatus[path] ?? false
                }
            }
            let rows = self.tableView.numberOfRows(inSection: tableView.numberOfSections-1)
            for row in 0..<rows {
                let lastSection = tableView.numberOfSections - 1
                let lastIndexPath = IndexPath(row: row, section: lastSection)
                cellStatus.removeValue(forKey: lastIndexPath)
            }
            
        }
        if let section = deleteSection {
            deleteCurrentSection(&cellButtonStatus, &headButtonStatus, section)
            deleteCurrentSection(&deleteCellButtonStatus, &deleteHeadButtonStatus, section)
            dataArray.remove(at: section)
            tableView.reloadData()
        }
        if shoppingBar.style == .normal {
            DispatchQueue.global().sync {
                self.updateDictionary()
                self.calculatePrice()
            }
        }
    }
}

// MARK: - 通过 删除 多个cell
extension ShoppingCartViewController{
    func deleteGoods(with cells: [String]) {
        for cell in cells {
            for i in 0..<dataArray.count {
                //var j = 0
                if dataArray[i].contains(cell) {
                    dataArray[i].remove(at: dataArray[i].index(of: cell)!)
                }
            }
        }
        dataArray = dataArray.filter({ (arr) -> Bool in
            return arr.count>0
        })
        deleteCellButtonStatus.removeAll()
        deleteHeadButtonStatus.removeAll()
        cellButtonStatus.removeAll()
        headButtonStatus.removeAll()
        tableView.reloadData()
    }
}

// MARK: - 想要购买的 和 想要删除的 cell
extension ShoppingCartViewController {
    /// 根据字典的 数值来更新价钱字典的数值
    func updateDictionary() {
        selectedCells.removeAll()
        let sectionNum = tableView.numberOfSections
        for section in 0..<sectionNum {
            let rowNum = tableView.numberOfRows(inSection: section)
            for row in 0..<rowNum {
                let indexPath = IndexPath(row: row, section: section)
                if let status = cellButtonStatus[indexPath], status == true {
                    var price: Float
                    var number: Int
                    if pricesDictionary[indexPath] == nil{
                        price = 499.00
                    }else {
                        price = Float.init(pricesDictionary[indexPath]!)!
                    }
                    if numberDictionary[indexPath] == nil{
                        number = 1
                    }else {
                        number = Int.init(numberDictionary[indexPath]!)!
                    }
                    selectedCells[indexPath] = (number, price)
                }else {
                    selectedCells.removeValue(forKey: indexPath)
                }
            }
        }
    }
    
    /// 更新想要删除的 cell的数组
    func updateDeleteCells(){
        deleteCells.removeAll()
        let sectionNum = tableView.numberOfSections
        for section in 0..<sectionNum {
            let rowNum = tableView.numberOfRows(inSection: section)
            for row in 0..<rowNum {
                let indexPath = IndexPath(row: row, section: section)
                if let status = deleteCellButtonStatus[indexPath], status == true {
                    deleteCells.append(dataArray[section][row])
                }
            }
        }
    }
}

