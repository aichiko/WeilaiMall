//
//  WeilaiViewController.swift
//  WeilaiMall
//
//  Created by 24hmb on 2017/2/26.
//  Copyright © 2017年 24hmb. All rights reserved.
//

import UIKit
import WebKit

class WeilaiViewController: ViewController {

    func push(path: String) {
        let controller = CCWebViewController()
        controller.path = path
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
    
    let locService = BMKLocationService()
    
    var webView = WKWebView(frame: CGRect.zero, configuration: WKWebViewConfiguration.init())
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        webView = configWebView(path: path)
        configLocation()
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
