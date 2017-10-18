//
//  ViewController.swift
//  OznerSoftTest
//
//  Created by macpro on 2017/10/17.
//  Copyright © 2017年 macpro. All rights reserved.
//

import UIKit
import CocoaAsyncSocket

class ViewController: UIViewController {

    var clientSocket:GCDAsyncSocket!
    
    var isConnectde:Bool = false
    
    @IBOutlet weak var wifiPwd: UITextField!
    @IBOutlet weak var wifiName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        print(GYTools.getWiFiInfo() ?? "" )
        wifiName.text = GYTools.getWiFiInfo() ?? ""
        
        clientSocket = GCDAsyncSocket.init(delegate: self, delegateQueue: DispatchQueue.main)
        
        
        //切换到设备发散的局域网
        try! clientSocket.connect(toHost: "10.10.10.1", onPort: 8080)
        
//        GYTools.openDeviceWiFiList()
    }

    
    @IBAction func beginSendPwd(_ sender: UIButton) {
        
        wifiPwd.resignFirstResponder()
        wifiName.resignFirstResponder()
        
        if isConnectde {
            
            let bytes:[UInt8] = [0xfe,0x00,0x25]
            
            clientSocket.write(Data.init(bytes: bytes), withTimeout: -1, tag: 0)
        }
        
    }
  

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        wifiPwd.resignFirstResponder()
        wifiName.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController:GCDAsyncSocketDelegate {
    
    
    func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        
        print("连接成功")
        clientSocket.readData(withTimeout: -1, tag: 0)
        isConnectde = true
    }
    
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        
        print(data)
        clientSocket.readData(withTimeout: -1, tag: 0)
        
    }
    
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        print("断开连接")
        isConnectde = false
        
    }
    
}

