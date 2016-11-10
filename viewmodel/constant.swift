//
//  constant.swift
//  viewmodel
//
//  Created by 赵希帆 on 2016/11/3.
//  Copyright © 2016年 赵希帆. All rights reserved.
//

import UIKit

enum development {
    case Debug
    case Development
    func getUrl() -> String? {
        switch self {
        case .Debug:
            return "http://www.gary123.applinzi.com/index.php/Home/Index/"
        default:
            return nil;
        }
    }
}

let Development : development = development.Debug

