//
//  CoreDataManager.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/3/19.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit
import CoreData

/// 主要用于存储 user 数据和更新数据
class CoreDataManager: NSObject {

    ///CoreData操作
    let EntityName = "User"
    
    let context: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if #available(iOS 10.0, *) {

            return appDelegate.persistentContainer.viewContext
        }else {
            return appDelegate.managedObjectContext
        }
    }()
    
    func addCoreData(user: UserModel) {
        //存在一个数据时，直接返回
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: EntityName);
        do {
            let rels = try context.fetch(request) as! [NSManagedObject];
            if rels.count > 0 {
                return
            }
        } catch  {
            fatalError(error.localizedDescription)
        }
        
        
        var entity = NSEntityDescription.insertNewObject(forEntityName: EntityName, into: context) as! User
        synchronization(userEntity: &entity, user: user)
        do {
            context.insert(entity)
            try context.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func getCoreData() -> User? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: EntityName);
        do {
            let rels = try context.fetch(request) as! [NSManagedObject];
            if rels.count == 0 {
                return nil
            }
            let rel = rels.first
            return rel as? User
        } catch  {
            fatalError(error.localizedDescription)
        }
    }
    
    func updateData(user: UserModel) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: EntityName);
        do {
            let rels = try context.fetch(request) as! [NSManagedObject];
            if rels.count == 0 {
                addCoreData(user: user)
                return
            }
            var userEntity = rels.first as? User
            synchronization(userEntity: &userEntity!, user: user)
            try context.save()
            
        } catch  {
            fatalError(error.localizedDescription)
        }
    }
    
    func deleteData() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: EntityName);
        do {
            let rels = try context.fetch(request) as! [NSManagedObject];
            for rel in rels {
                context.delete(rel)
            }
        } catch  {
            fatalError(error.localizedDescription)
        }
        
    }
    
    func getUserModel() -> UserModel? {
        if let user = getCoreData() {
            return UserModel(user: user)
        }
        return nil
    }
    
    func updateUser(with parameters: [String: Any]) throws {
        if let user = getCoreData() {
            
            let keys = ["real_name", "birthday", "sex", "user_picture"]
            
            for item in parameters {
                if keys.contains(item.key) {
                    user.setValue(item.value, forKey: item.key)
                }else {
                    throw NSError.init(domain: "参数错误", code: 0, userInfo: nil)
                }
            }
        }
    }
    
    
    private func synchronization(userEntity: inout User, user: UserModel) {
        userEntity.user_id = Int64(user.user_id)
        userEntity.user_name = user.user_name
        userEntity.real_name = user.real_name
        userEntity.mobile_phone = Int64(user.mobile_phone)
        userEntity.email = user.email
        userEntity.sex = Int64(user.sex)
        userEntity.birthday = user.birthday
        userEntity.user_money = user.user_money
        userEntity.rebate = user.rebate
        userEntity.highreward = user.highreward
        userEntity.payin = user.payin
        userEntity.pay_points = user.pay_points
        userEntity.user_picture = user.user_picture
    }
    
}
