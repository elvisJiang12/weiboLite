//
//  Statuses.swift
//  weiboLite
//
//  Created by Elvis on 2018/1/26.
//  Copyright © 2018年 Elvis. All rights reserved.
//

import UIKit

///登录用户的微博数据模型
@objcMembers
class Status: NSObject {
    
    //MARK:- 定义属性
    var created_at : String?            //微博创建时间
    var mid : Int64 = 0                 //微博MID
    var text : String?                  //微博信息内容
    var souceForDisplay : String?       //供界面展示的"微博来源"
    var source : String? = nil {              //微博来源
        didSet { //属性监听器
            //1.nil值校验
            guard let source = source, source != "" else {
                return souceForDisplay = "未知设备"
            }
            //2.对原始字符串进行处理
            //2.1获取字符串起始的位置和需要截取的长度
            let startIndex = (source as NSString).range(of: "nofollow\">").location + 10
            let length = (source as NSString).range(of: "</a>").location - startIndex
            //2.2截取字符串
            souceForDisplay = (source as NSString).substring(with: NSRange(location: startIndex, length: length))
        }
    }

    //MARK:- 自定义构造函数
    init(dict: [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }
    
}
