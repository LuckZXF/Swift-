//
//  messageAip.swift
//  viewmodel
//
//  Created by 赵希帆 on 2016/11/4.
//  Copyright © 2016年 赵希帆. All rights reserved.
//

import UIKit
import Moya

/**
 *  模块化网络请求：
 *  将网络请求模块化（例如：PigApi,TigerApi,CatApi）
 *  可按业务模块分割
 *
 */


enum Messageapi {
    case search
    case add(messageTitle : String, messageContent : String)
    case delete(messageId : String)
}

extension Messageapi : TargetType {
    
    var baseURL : URL {
        return URL.init(string: Development.getUrl()!)!
    }
    
    var path : String {
        switch self {
        case .search:
            return "search"
        case .add:
            return "add"
        case .delete:
            return "delete"
        }
    }
    
    var method : Moya.Method {
        switch self {
        case .search, .add, .delete:
            return .post
        default:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .add(messageTitle: let title, messageContent: let content):
            return ["messageTitle": title, "messageContent": content]
        case .delete(messageId: let id):
            return ["messageId" : id]
        default:
            return nil
        }
    }
    
    var parameterEncoding : Moya.ParameterEncoding {
        return JSONEncoding.default
    }
    
    var sampleData: Data {
        switch self {
        case .search:
            return Data(base64Encoded: "")!
        case .add(messageTitle: let title, messageContent: let content):
            return "{\"messageTitle\": \"\(title)\", \"messageContent\": \"\(content)\"}".data(using: String.Encoding.utf8)!
        default:
            return "{\"login\": \"()\", \"id\": 100}".data(using: String.Encoding.utf8)!
        }
    }
    
    var task: Task {
        return .request
    }
    
}

class messageApi: Network {
    
    var param : Any?
    
    // MARK: 消息Api类型枚举
    enum messageNetwork {
        case search
        case add
        case delete
        func getMessageApiUrl() -> String? {
            switch self {
            case .search:
                return "\(Development.getUrl()!)search"
            case .add:
                return "\(Development.getUrl()!)add"
            case .delete:
                return "\(Development.getUrl()!)delete"
            }
        }
        func getMessageApiParams(data : Any?) -> Dictionary<String,Any>? {
            switch self {
            case .search: return nil
            case .add:
                return ["messageTitle" : "陈健龙", "messageContent" : "谁能比我更傻逼"];
            case .delete:
                return ["messageId" : (data as! String)];
            }
        }
    }
    
    var messageApiName : messageNetwork? {
        didSet {
            url = self.messageApiName?.getMessageApiUrl()
            params = self.messageApiName?.getMessageApiParams(data: param)
        }
    }
    
}









