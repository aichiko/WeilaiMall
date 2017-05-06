//
//  WeilaiViewController.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/2/26.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit
import WebKit
import CoreLocation

class WeilaiViewController: ViewController {

    func push(path: String) {
        let controller = CCWebViewController()
        controller.path = path
        if path.hasPrefix("http") {
            // 传入完整的网址的情况下，直接打开相应的地址
            controller.requestURL = path
        }
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func pop(root: Bool = false) {
        if root {
            self.navigationController?.popToRootViewController(animated: true)
        }else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    var path: String = "local"
    
    let manager = CLLocationManager()
    
    
    var webView = WKWebView(frame: CGRect.zero, configuration: WKWebViewConfiguration.init())
    
    var leftItem = UIBarButtonItem()
    
    var rightItem = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let configuration = WKWebViewConfiguration()
        let userContent = WKUserContentController()
        userContent.add(self, name: "push")
        userContent.add(self, name: "pop")
        
        configuration.userContentController = userContent
        
        webView = WKWebView(frame: CGRect.zero, configuration: configuration)
        webView.load(URLRequest.init(url: URL.init(string: webViewHost+path)!))
        self.view.addSubview(webView)
        self.automaticallyAdjustsScrollViewInsets = false
        webView.snp.updateConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(64)
            make.bottom.equalTo(-48)
        }
        webView.uiDelegate = self
        webView.navigationDelegate = self
        configLocation()
        navigationAttribute()
    }
    
    func navigationAttribute() {
        
        rightItem = UIBarButtonItem.init(image: UIImage.init(named: "scan_btn")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(scanCode(item:)))
        
        
        leftItem = UIBarButtonItem.init(title: "全部", style: .done, target: self, action: nil)
        leftItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont.CCsetfont(14)!], for: .normal)
        self.navigationItem.leftBarButtonItem = leftItem
        self.navigationItem.rightBarButtonItem = rightItem
        addSearchView()
    }
    
    
    func addSearchView() {
        let grayView = UIView()
        grayView.backgroundColor = UIColor(red:0.92, green:0.92, blue:0.92, alpha:1.00)
        grayView.layer.masksToBounds = true
        grayView.layer.cornerRadius = 15
        //addSubview(grayView)
        grayView.frame = CGRect(x: 0, y: 0, width: 300*self.view.bounds.width/375, height: 30)
        
        let searchIcon = UIImageView.init(image: UIImage.init(named: "search_icon"))
        grayView.addSubview(searchIcon)
        searchIcon.snp.updateConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(10)
        }
        
        grayView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(searchShow(tap:))))
        self.navigationItem.titleView = grayView
        
    }
    
    @objc private func scanCode(item: UIBarButtonItem) {
        self.performSegue(withIdentifier: "weilai_scanCode", sender: self)
    }
    
    @objc private func searchShow(tap: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "weilai_search", sender: self)
    }
    
    
    
    /// 配置定位功能
    func configLocation() {
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    deinit {
        webView.configuration.userContentController.removeScriptMessageHandler(forName: "push")
        webView.configuration.userContentController.removeScriptMessageHandler(forName: "pop")
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "weilai_search" {
            if let controller = segue.destination as? UINavigationController {
                let searchVC = controller.visibleViewController as! HomeSearchViewController
                searchVC.path = "classifyList"
            }
        }
    }
    

}

extension WeilaiViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
        cityName(locations[0])
    }
    
    
    func cityName(_ userLocation: CLLocation) {
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation) { [unowned self] (array, error) in
            if let arr = array, arr.count > 0 {
                let placemark: CLPlacemark = arr[0]
                let city = placemark.locality
                print("当前城市名称------\(city!)")
                self.leftItem.title = city
                //找到了当前位置城市后就关闭服务
                self.manager.stopUpdatingLocation()
                if self.path.contains("long") && self.path.contains("lat") {
                    return
                }else {
                    self.path.append("?long=\(userLocation.coordinate.longitude)&lat=\(userLocation.coordinate.latitude)")
                }
                print(self.path)
                self.reloadWebView(path: self.path, webView: self.webView)
            }
        }
    }
}
/*
extension WeilaiViewController: BMKLocationServiceDelegate {
    /*
    func didUpdateUserHeading(_ userLocation: BMKUserLocation!) {
        NSLog("heading is %@",userLocation.heading);
    }
    */
    func didUpdate(_ userLocation: BMKUserLocation!) {
        NSLog("didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
        
        cityName(userLocation)
        
    }
    
    func cityName(_ userLocation: BMKUserLocation) {
        var region = BMKCoordinateRegion()
        region.center.latitude  = userLocation.location.coordinate.latitude;
        region.center.longitude = userLocation.location.coordinate.longitude;
        region.span.latitudeDelta = 0;
        region.span.longitudeDelta = 0;
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation.location) { (array, error) in
            if let arr = array, arr.count > 0 {
                let placemark: CLPlacemark = arr[0]
                let city = placemark.locality
                print("当前城市名称------\(city!)")
                let offlineMap = BMKOfflineMap()
                let records = offlineMap.searchCity(city) as! [BMKOLSearchRecord]
                let oneRecord: BMKOLSearchRecord = records[0]
                //城市编码如:北京为131
                let cityId = oneRecord.cityID;
                
                print("当前城市编号-------->",cityId);
                //找到了当前位置城市后就关闭服务
                self.locService.stopUserLocationService()
            }
        }
    }
    
    func didFailToLocateUserWithError(_ error: Error!) {
        print(error)
    }
}
 */

extension WeilaiViewController: WKScriptMessageHandler, WKNavigationDelegate, WKUIDelegate {
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "push" {
            print(message.body)
            push(path: message.body as! String)
        }else if message.name == "pop" {
            print(message.body)
            pop(root: message.body as? Bool ?? false)
        }
    }
}
