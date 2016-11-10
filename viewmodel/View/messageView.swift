//
//  messageView.swift
//  viewmodel
//
//  Created by 赵希帆 on 2016/10/31.
//  Copyright © 2016年 赵希帆. All rights reserved.
//

import UIKit

/**
 *  View层 （关联关系如下）
 *  逻辑层: view只负责action触发和传递数据，逻辑层做数据处理
 *  view层瘦身 业务逻辑出错可以跳过view层
 */

class messageView: UIViewController, UITableViewDelegate, UITableViewDataSource, messageInterface {
    
    var tableDataSource : Array<message>?
    var messageDelegate : messageAction?
    var editButton : Bool = false
    
    lazy var tableview : UITableView = {
        var tv : UITableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), style: .plain)
        tv.register(UINib.init(nibName: "messagecell", bundle: nil), forCellReuseIdentifier: "messagecell")
        tv.tableFooterView = UIView()
        return tv
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageDelegate = messageAction()
        messageDelegate?.delegate = self;
        self.view.addSubview(self.tableview)
        self.tableview.delegate = self
        self.tableview.dataSource = self
        
        let rightBarBtn : UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(self.addMessageAction))
        self.navigationItem.rightBarButtonItem = rightBarBtn
        let leftBarBtn: UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .edit, target: self, action: #selector(self.deleteMessageAcition))
        self.navigationItem.leftBarButtonItem = leftBarBtn
        
        messageDelegate?.sendSearchRequest()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableDataSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = "messagecell"
        guard let messagecell = tableView.dequeueReusableCell(withIdentifier: cell, for: indexPath) as? messagecell else {
            fatalError("cell with identifier 'foo' and class 'MyCustomCell' not found. "
                + "Check that your XIB/Storyboard is configured properly.")
        }

        if let message = tableDataSource?[indexPath.row] {
            messagecell.initMessageCell(message)
        }
//        messagecell.settingBtn.tag = indexPath.row
//        messagecell.settingBtn.addTarget(self, action: #selector(messageSetting(_:)), for: .touchUpInside)
        
        return messagecell
    }
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let message = tableDataSource?[indexPath.row] {
            let messageModel = messageDelegate?.click(message)
            self.tableDataSource![indexPath.row] = messageModel!
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        messageDelegate?.sendDeleteMessageRequest(message: (self.tableDataSource?[indexPath.row])!, index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
    
    // MARK:  Event 触发事件
    
    func addMessageAction() {
        messageDelegate?.sendAddMessageRequest()
    }
    
    func deleteMessageAcition() {
        if self.tableDataSource != nil {
            self.editButton = !self.editButton
            self.tableview.setEditing(self.editButton, animated: true)
        }
    }
    
    // MARK: messageDelegate 回调
    func add(_ message: message) {
        self.tableDataSource?.append(message)
        self.tableview.reloadData()
    }
    
    func delete(index: Int) {
        self.tableDataSource?.remove(at: index)
        self.tableview.reloadData()
    }
    
    func search(_ messageArr: Array<message>) {
        if self.tableDataSource == nil {
            self.tableDataSource = Array<message>()
        }
        self.tableDataSource = messageArr
        self.tableview.reloadData()
    }
}
