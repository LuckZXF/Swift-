//
//  Network.swift
//  viewmodel
//
//  Created by 赵希帆 on 2016/11/4.
//  Copyright © 2016年 赵希帆. All rights reserved.
//

import UIKit
import Alamofire
import Moya

typealias successCallBack = (Dictionary<String,Any>)->()
typealias failureCallBack = (NSError)->()


class Network {
    
    var url : String? = nil
    var params : Dictionary<String,Any>? = nil
    
    private static let shareInstance = Network()
    
    class var shareManage : Network {
        return shareInstance
    }
    
    func sendNetWork(success : @escaping successCallBack, firlure : @escaping failureCallBack) {
        Alamofire.request(URL.init(string: url!)!, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { (reponse) in
            //是否请求成功
            switch reponse.result
            {
            case let .success(Value):
                success(Value as! Dictionary<String, Any>)
            case let .failure(Error):
                firlure(Error as NSError)
            }
        } 
    }
    
    private init(){}
    
}
