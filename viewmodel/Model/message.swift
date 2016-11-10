//
//  message.swift
//  viewmodel
//
//  Created by 赵希帆 on 2016/10/31.
//  Copyright © 2016年 赵希帆. All rights reserved.
//

import UIKit
import YYModel
import LKDBHelper

/**
 *  模型层 （关联关系如下）
 *  DAO层: 需要缓存的在数据变更后更新本地数据库 （可加接口自动缓存）
 *  逻辑层: 提供模型的处理逻辑接口给逻辑层
 *  
 */

enum messageType {
    case getName
    case changeName
}

class message : NSObject,YYModel{
    var messageId : String?
    var messageTitle : String?
    var messageContent : String?
    var messageTime : String?
    
    init( messageId : String = "", messageTitle : String = "", messageContent : String = "", messageTime : String = "") {
        
        self.messageId = messageId
        self.messageTitle = messageTitle
        self.messageContent = messageContent
        self.messageTime = messageTime
    }
    
    static func modelCustomPropertyMapper() -> [String : Any]? {
        return [
            "messageId" : "messageid",
            "messageTitle" : "messagetitle",
            "messageContent" : "messagecontent",
            "messageTime" : "messagetime"
        ]
    }
}

