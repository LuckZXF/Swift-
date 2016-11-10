//
//  messagecell.swift
//  viewmodel
//
//  Created by 赵希帆 on 2016/10/31.
//  Copyright © 2016年 赵希帆. All rights reserved.
//

import UIKit


class messagecell : UITableViewCell {
    
    @IBOutlet var messageTitle: UILabel!
    @IBOutlet var messageContent: UILabel!
    @IBOutlet var messageTime: UILabel!
//    @IBOutlet var settingBtn: UIButton!
    
    func initMessageCell( _ message : message) {
        self.messageTitle.text = message.messageTitle
        self.messageContent.text = message.messageContent
        self.messageTime.text = message.messageTime
    }
    
}
