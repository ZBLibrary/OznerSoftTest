//
//  OznerTools.swift
//  OznerLibrarySwiftyDemo
//
//  Created by 赵兵 on 2017/1/5.
//  Copyright © 2017年 net.ozner. All rights reserved.
//

import UIKit

struct MqttSendStruct {
    
    var key:String = ""
    var value:Any = ""
    var type:String = ""
    
}

class OznerTools: NSObject {
    
    //2G
    class func mqttModelToData(_ models:[MqttSendStruct]) -> Data {
        
        var arr = [[String:Any]]()
        
        for model in models {
            
            let keyModel = ["key":model.key,"value":model.value,"type":model.type,"updateTime":Date().timeIntervalSince1970]
            arr.append(keyModel)
        }
        
//        let arr = [["key":model.key,"value":model.value,"type":model.type,"updateTime":Date().timeIntervalSince1970]]
        
        let data = try! JSONSerialization.data(withJSONObject: arr, options: JSONSerialization.WritingOptions.prettyPrinted)
        
        return data
    }
    
    
    class func dataFromInt16(number:UInt16)->Data {
        
        let data = NSMutableData()
        //        var val = CFSwapInt16HostToBig(number)
        var val = CFSwapInt16LittleToHost(number)
        
        data.append(&val, length: MemoryLayout<UInt16>.size)
        
        return data as Data
    }
    
    class func dataFromInt(number:CLongLong,length:Int)->Data{
        var data=Data()
        if length<1 {
            return data
        }
        var tmpValue = CLongLong(0)
        for i in 0...(length-1) {
            let powInt = CLongLong(pow(CGFloat(256), CGFloat(i)))
            let needEle=(number-tmpValue)/powInt%256
            data.append(UInt8(needEle))
            tmpValue+=CLongLong(needEle)*powInt
        }
        return data
    }
    
    class func hexStringFromData(data:Data)->String{
        var hexStr=""
        for i in 0..<data.count {
            if Int(data[i])<16 {
                hexStr=hexStr.appendingFormat("0")
            }
            hexStr=hexStr.appendingFormat("%x",Int(data[i]))
        }
        return hexStr
    }
    
    class func hexStringToData(strHex:String)->Data{
        var data=Data()
        if strHex.characters.count%2 != 0 {
            return data
        }
        for i in 0..<strHex.characters.count/2 {
            let range1 = strHex.index(strHex.startIndex, offsetBy: i*2)
            let range2 = strHex.index(strHex.startIndex, offsetBy: i*2+2)
            let hexString = strHex.substring(with: Range(range1..<range2))
            var result1:UInt32 = 0
            Scanner(string: hexString).scanHexInt32(&result1)
            data.insert(UInt8(result1), at: i)
        }
        return data
    }
    
    class func publicGPRSString(deviceType:String,deviceId:String,key:String,value:AnyObject,callback:((Int32)->Void)!){
        let params = ["deviceType" : deviceType,
                      "deviceId" : deviceId,
                      "key" : key,
                      "value" : value] as [String : Any]//设置参数

        Helper.post("http://iot.ozner.net:1885/setter.do", requestParams: params) { (response, data, error) in
            print(error ?? "")
        }
      
    }
    class func publicString(payload:Data,deviceid:String,callback:((Int32)->Void)!){
        let payloadStr=OznerTools.hexStringFromData(data: payload)
        let params = ["username" : "bing.zhao@cftcn.com","password" : "l5201314","deviceid" : deviceid,"payload" : payloadStr]//设置参数
        //print("2.0发送指令："+payloadStr)
        Helper.post("https://v2.fogcloud.io/enduser/sendCommandHz/", requestParams: params) { (response, data, error) in
            print(error ?? "")
        }
        
    }
    
}
extension Data{
    
    func subInt(starIndex:Int,count:Int) -> Int {
        if starIndex+count>self.count {
            return 0
        }
        var dataValue = 0
        for i in 0..<count {
            dataValue+=Int(Float(self[i+starIndex])*powf(256, Float(i)))
        }
        return dataValue
    }
    
    func subString(starIndex:Int,count:Int) -> String {
        if starIndex+count>self.count {
            return ""
        }
        let range1 = self.index(self.startIndex, offsetBy: starIndex)
        let range2 = self.index(self.startIndex, offsetBy: starIndex+count)
        let valueData=self.subdata(in: Range(range1..<range2))
        return String.init(data: valueData, encoding: String.Encoding.utf8)!
    }
    
    func subData(starIndex:Int,count:Int) -> Data {
        if starIndex+count>self.count {
            return Data.init()
        }
        let range1 = self.index(self.startIndex, offsetBy: starIndex)
        let range2 = self.index(self.startIndex, offsetBy: starIndex+count)
        return self.subdata(in: Range(range1..<range2))
    }
}

extension Double {
    public func roundTo(_ places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
