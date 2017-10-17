//
//  ViewController.swift
//  OznerSoftTest
//
//  Created by macpro on 2017/10/17.
//  Copyright © 2017年 macpro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        print(GYTools.getWiFiInfo() ?? "" )
        
        sleep(1)
        
        GYTools.openDeviceWiFiList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

