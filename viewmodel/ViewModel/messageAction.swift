//
//  messageAction.swift
//  viewmodel
//
//  Created by 赵希帆 on 2016/10/31.
//  Copyright © 2016年 赵希帆. All rights reserved.
//

import UIKit
import Alamofire
import Moya
import YYModel
import LKDBHelper

/**
 *  逻辑层 （关联关系如下）
 *  view: 页面逻辑全在这层做处理 处理完毕后页面只负责刷新
 *  model: 逻辑处理完后更新model数据
 *  network: 发送网络请求与接收网络请求回调
 */



/// message逻辑处理回调到view层页面接口
protocol messageInterface {
    func add(_ message : message)
    func delete(index : Int)
    func search(_ messageArr: Array<message>)
}

class messageAction {

//    lazy var api : messageApi = {
//       var api1 = messageApi()
//        return api1
//    }()
    
    var delegate : messageInterface?
    
    func click(_ message: message) -> message{
        message.messageTime = "1993-03-28"
        message.messageTitle = "赵希帆"
        message.messageContent = "拥有很多很多的儿子，比如GAY佬"
        return message
    }
    
    
    // MARK: Network Resquest
    
    func sendSearchRequest() {
//        self.api.param = nil
//        self.api.messageApiName = messageApi.messageNetwork.search
//        self.api.sendNetWork(success: { (resultDic) in
//            if resultDic["status"] as! String == "0" {
//                let arr : Array<Any> = resultDic["data"] as! Array<Any>
//                var msgArr : Array<message> = Array<message>()
//                for i in arr {
//                    var dic : Dictionary<String,String> = i as! Dictionary<String,String>
//                    let msg : message = message.init()
//                    msg.messageId = dic["messageid"]
//                    msg.messageTitle = dic["messagetitle"]
//                    msg.messageContent = dic["messagecontent"]
//                    msgArr.append(msg)
//                }
//                self.delegate?.search(msgArr)
//            }
//        }, firlure: { (Error) in
//            print(Error)
//        })
        
        //清除本地消息表缓存
        message.dropToSql()
        let provider = MoyaProvider<Messageapi>()
        provider.request(.search ){ result in
            switch result {
            case let .success(response):
                do {
                    if let resultDic = try response.mapJSON() as? Dictionary<String,Any> {
                        self.searchSuccessCallBack(resultDic: resultDic)
                    } else {}
                } catch {}
            case let .failure(error):
                print(error)
            }
        }

    }
    
    func sendAddMessageRequest() {
//        self.api.param = nil
//        self.api.messageApiName = messageApi.messageNetwork.add
//        self.api.sendNetWork(success: { (resultDic) in
//            if resultDic["status"] as! String == "0" {
//                let arr : Array<Any> = resultDic["data"] as! Array<Any>
//                var dic : Dictionary<String,String> = arr.first as! Dictionary<String,String>
//                let msg : message = message.init()
//                msg.messageId = dic["messageid"]
//                msg.messageTitle = dic["messagetitle"]
//                msg.messageContent = dic["messagecontent"]
//                self.delegate?.add(msg)
//            }
//        }, firlure: { (Error) in
//            print(Error)
//        })
        
       
        let provider = MoyaProvider<Messageapi>()
        provider.request(.add(messageTitle: "陈健龙", messageContent: "我家门口修地铁")) { result in
            switch result {
            case let .success(response):
                do {
                    if let resultDic = try response.mapJSON() as? Dictionary<String,Any> {
                            self.addSuccessCallBack(resultDic: resultDic)
                    }
                } catch {}
            case let .failure(error):
                print(error)
            }
        }
     }
    
    func sendDeleteMessageRequest(message : message,index : Int) {
//        self.api.param = message.messageId
//        self.api.messageApiName = messageApi.messageNetwork.delete
//        self.api.sendNetWork(success: { (resultDic) in
//            if resultDic["status"] as! String == "0" {
//                self.delegate?.delete(index: index)
//            }
//        }, firlure: { (Error) in
//            print(Error)
//        })
        let provider = MoyaProvider<Messageapi>()
        provider.request(.delete(messageId: message.messageId!)) { result in
            switch result {
            case let .success(response):
                do {
                    if let resultDic = try response.mapJSON() as? Dictionary<String,Any> {
                        self.deleteSuccessCallBack(resultDic: resultDic,index: index)
                        //如果需要删除本地缓存则增加下面代码
                        message.deleteToSql()
                    }
                } catch {}
            case let .failure(error):
                print(error)
            }
        }
    }
   
    // MARK: Network Response
    func searchSuccessCallBack(resultDic : [String : Any]){
        let arr : Array<Any> = resultDic["data"] as! Array<Any>
        var msgArr : Array<message> = Array<message>()
        for i in arr {
            let dic : Dictionary<String,String> = i as! Dictionary<String,String>
            let msg : message = message()
            msg.yy_modelSet(withJSON: dic)
            msgArr.append(msg)
            //如果需要本地缓存则增加下面代码
            msg.saveToSql()
        }
        self.delegate?.search(msgArr)
    }
    
    func addSuccessCallBack(resultDic : [String : Any]) {
        let arr : Array<Any> = resultDic["data"] as! Array<Any>
        let dic : Dictionary<String,String> = arr.first as! Dictionary<String,String>
        let msg : message = message.init()
        msg.yy_modelSet(withJSON: dic)
        self.delegate?.add(msg)
        //如果需要本地缓存则增加下面代码
        msg.addToSql()
    }
    
    func deleteSuccessCallBack(resultDic : [String : Any], index : Int) {
        if resultDic["status"] as! String == "0" {
            self.delegate?.delete(index: index)
        }
    }
    
}

