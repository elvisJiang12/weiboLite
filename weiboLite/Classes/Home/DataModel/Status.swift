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
    var source : String?                //微博来源
    var userInfo : StatusUserInfo?          //微博作者的用户信息
    
    //MARK:- 自定义构造函数
    init(dict: [String : Any]) {
        super.init()
        setValuesForKeys(dict)
        
        //微博作者的用户信息字典转模型
        if let userdict = dict["user"] as? [String : Any] {
            userInfo = StatusUserInfo.init(dict: userdict)
        }
        
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }
    
}
