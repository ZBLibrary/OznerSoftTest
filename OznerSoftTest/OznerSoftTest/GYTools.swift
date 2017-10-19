//
//  GYTools.swift
//  OznerSoftTest
//
//  Created by ZGY on 2017/10/17.
//Copyright © 2017年 macpro. All rights reserved.
//
//  Author:        Airfight
//  My GitHub:     https://github.com/airfight
//  My Blog:       http://airfight.github.io/
//  My Jane book:  http://www.jianshu.com/users/17d6a01e3361
//  Current Time:  2017/10/17  下午3:48
//  GiantForJade:  Efforts to do my best
//  Real developers ship.

import UIKit
import SystemConfiguration.CaptiveNetwork

class GYTools: NSObject {

    
    /// get WIFI SSID
    ///
    /// - Returns: SSID
    static func getWiFiInfo() -> String? {
        
//        let interfaces = CNCopySupportedInterfaces()
//        var ssid = ""
//        if interfaces != nil {
//            let interfacesArray = CFBridgingRetain(interfaces) as! Array<AnyObject>
//            if interfacesArray.count > 0 {
//                let interfaceName = interfacesArray[0] as! CFString
//                let ussafeInterfaceData = CNCopyCurrentNetworkInfo(interfaceName)
//                if (ussafeInterfaceData != nil) {
//                    let interfaceData = ussafeInterfaceData as! Dictionary<String, Any>
//                    ssid = interfaceData["SSID"]! as! String
//                }
//            }
//        }
//        return ssid
        
        if let cfas:NSArray = CNCopySupportedInterfaces() {

            for cfa in cfas {

                if let dict = CFBridgingRetain((CNCopyCurrentNetworkInfo(cfa as! CFString))) {
                    if let ssid = dict["SSID"] as? String {

                        return ssid
                    
                    }
                }

            }

        }

        return nil
    }
    
    
    /// oper WiFi List
    static func openDeviceWiFiList() {
//        let urlString = "App-Prefs:root=WIFI"
//
//        if UIApplication.shared.canOpenURL(URL(string: urlString)!) {
//
//            if #available(iOS 10.0, *) {
//                UIApplication.shared.open(URL(string: urlString)!, options:[:], completionHandler: { (isBack) in
//                    if isBack {
//                        print("返回了")
//                    }
//                })
//            } else {
//                UIApplication.shared.openURL(URL(string: urlString)!)
//            }
//
//        }
        
        if let url = URL(string:"App-Prefs:root=WIFI") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        
    }
    
    static func decTohex(number:Int) -> String {
        return String(format: "%0X", number)
    }
    
}
