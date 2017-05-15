//
//  AppDelegate.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/2/23.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManager
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        
        window?.makeKeyAndVisible()
        
        //版本更新提示，每次进入app都会调用
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 5) {
            self.versionUpdate()
        }
        
        /// 第一次进入时的引导图
        if firstLaunch {
            let mainVC
                = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "main")
            self.window?.rootViewController = mainVC
        }else {
            let mainVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "main")
            CCLaunchViewController.showLaunchView(click: { () -> UIView in
                return mainVC.view
            }) {
                UserDefaults.init().set(true, forKey: "firstLaunch")
                self.window?.rootViewController = mainVC
            }
        }
        
        WXApi.registerApp("wx4f78b3936551e90c")
        return true
    }
    
    func versionUpdate() {
        
        struct VersionMessage {
            /// 是否最新版本  0 否 ； 1 是
            var renew: Bool
            /// 版本号
            var version: String
            /// 版本更新内容
            var content: String
            /// 下载地址
            var url: String
            /// 是否强制更新  0 否   1是
            var type: Bool
            
            init(value: JSON) {
                renew = value["renew"].boolValue
                version = value["version"].stringValue
                content = value["content"].stringValue
                url = value["url"].stringValue
                type = value["type"].boolValue
            }
        }
        
        struct VersionUpdateRequest: CCRequest {
            let path: String = checkversion
            
            var parameter: [String: Any]
            typealias Response = VersionMessage
            
            func JSONParse(value: JSON) -> [VersionMessage?]? {
                return [VersionMessage.init(value: value["data"])]
            }
        }
        
        func versionUpdateInfo(with model: VersionMessage) -> ()->Void {
            if !model.renew {
                let alertController = UIAlertController.init(title: "版本更新", message: model.content, preferredStyle: .alert)
                let sureAction = UIAlertAction.init(title: "确定", style: .default, handler: { (alert) in
                    guard model.url.characters.count > 0 else {
                        return
                    }
                    UIApplication.shared.openURL(URL.init(string: model.url)!)
                })
                let cancelAction = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
                alertController.addAction(sureAction)
                alertController.addAction(cancelAction)
                window?.rootViewController?.present(alertController, animated: true, completion: nil)
            }
            return {}
        }
        
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        
        let request = VersionUpdateRequest(parameter: ["phonetype":2, "version": version])
        URLSessionClient().alamofireSend(request) { (models, error) in
            if error == nil {
                if models.count > 0, let model = models[0] {
                    versionUpdateInfo(with: model)()
                }
            }
        }
        
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if url.host == "safepay" {
            AlipaySDK.defaultService().processOrder(withPaymentResult: url, standbyCallback: { (resultDic) in
//                print("result = \(resultDic)");
                NotificationCenter.default.post(name: ALIPayResult, object: self, userInfo: ["response": resultDic!])
            })
        }
        
        return true
    }
    
    // NOTE: 9.0以后使用新API接口
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.host == "safepay" {
            AlipaySDK.defaultService().processOrder(withPaymentResult: url, standbyCallback: { (resultDic) in
//                print("result = \(resultDic)");
                NotificationCenter.default.post(name: ALIPayResult, object: self, userInfo: ["response": resultDic!])
            })
        }
        return true
    }
    

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        if #available(iOS 10.0, *) {
            self.saveContext()
        } else {
            // Fallback on earlier versions
        }
    }

    // MARK: - Core Data stack

    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "WeilaiMall")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    lazy var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    //iOS9下的 Core Data stack
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: "WeilaiMall", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("WeilaiMall.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    //iOS9下的 Core Data stack结束
    
    // MARK: - Core Data Saving support

    @available(iOS 10.0, *)
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

