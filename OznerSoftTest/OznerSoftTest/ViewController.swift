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
//        wifiName.text = GYTools.getWiFiInfo() ?? ""
        wifiName.text = "haoze"
        wifiPwd.text = "12344321"
        
        sleep(3)
        
        clientSocket = GCDAsyncSocket.init(delegate: self, delegateQueue: DispatchQueue.main)
        
        
        //切换到设备发散的局域网
        try! clientSocket.connect(toHost: "10.10.10.1", onPort: 8080)
        
        sleep(3)
        
//        GYTools.openDeviceWiFiList()
    }

    @IBAction func sendSureAction(_ sender: UIButton) {
        
    }
    
    @IBAction func beginSendPwd(_ sender: UIButton) {
        
        wifiPwd.resignFirstResponder()
        wifiName.resignFirstResponder()
     
        
        if isConnectde {
            var sumDatas = Data()
//            let bytes:[UInt8] = [0xfe,0x0e,0x00,0x25,0x05]
//            let ssidData = "Giant".data(using: String.Encoding.utf8)
//            let keyLen = Data.init(bytes: [0x09])
            let ssidLength:Int = wifiName.text!.characters.count
            let keyLegth:Int = wifiPwd.text!.characters.count
//            UInt8(GYTools.decTohex(number: ssidLength + keyLegth))!
            let bytes:[UInt8] = [0xfe,0x0d,0x00,0x25,UInt8(GYTools.decTohex(number: ssidLength))!]
            
            let ssidData = wifiName.text!.data(using: String.Encoding.utf8)
            let keyLen = Data.init(bytes: [UInt8(GYTools.decTohex(number: keyLegth))!])
            
            sumDatas.append(Data.init(bytes: bytes))
            sumDatas.append(ssidData!)
            sumDatas.append(keyLen)
            sumDatas.append(wifiPwd.text!.data(using: String.Encoding.utf8)!)
//            sumDatas.append(Data.init(bytes: [0x00,0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x08]))
            let checkBytes = UnsafeMutablePointer<UInt8>.allocate(capacity: sumDatas.count)
            for i in 0..<sumDatas.count {
                
                checkBytes[i] = sumDatas[i]
                
            }
            
            let lastByte = Helper.crc8(checkBytes, inLen: UInt16(sumDatas.count))
            
            sumDatas.append(lastByte)
            
            clientSocket.write(sumDatas, withTimeout: -1, tag: 0)
            
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
        
        var keyLen = Data.init(bytes: [0xfe,0x05,0x00,0x26])
        let checkBytes = UnsafeMutablePointer<UInt8>.allocate(capacity: keyLen.count)
        for i in 0..<keyLen.count {
            
            checkBytes[i] = keyLen[i]
            
        }
        let lastByte = Helper.crc8(checkBytes, inLen: UInt16(keyLen.count))
        keyLen.append(lastByte)

        clientSocket.write(keyLen, withTimeout: -1, tag: 0)
        
    }
    
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
//        print("断开连接")
        
        if !isConnectde {
            try! clientSocket.connect(toHost: "10.10.10.1", onPort: 8080)
            sleep(2)
        }
        
        isConnectde = false
        
    }
    
}

