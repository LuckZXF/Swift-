//
//  MessageDao.swift
//  viewmodel
//
//  Created by 赵希帆 on 2016/11/9.
//  Copyright © 2016年 赵希帆. All rights reserved.
//

import Foundation
import LKDBHelper
import YYModel

/**
 *  数据持久层：
 *  负责管理本地缓存的表信息
 *  增删改查等数据库操作
 *
 */

extension message {
    override static func getPrimaryKey() -> String {
        return "messageId"
    }
    
    override static func getTableName() -> String {
        return "message"
    }
    
    class func dropToSql() {
        let globalHelper = message.getUsingLKDBHelper()
        
        ///删除所有表   delete all table
        globalHelper.dropAllTable()
        
        //清空表数据  clear table data
        LKDBHelper.clearTableData(message.self)
    }
    
    func saveToSql() {
        self.saveToDB()
    }
    
    func deleteToSql(){
        self.deleteToDB()
    }
    
    func addToSql() {
        self.saveToDB()
    }
    
}
