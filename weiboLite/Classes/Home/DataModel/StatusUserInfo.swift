//
//  StatusUserInfo.swift
//  weiboLite
//
//  Created by Elvis on 2018/1/26.
//  Copyright © 2018年 Elvis. All rights reserved.
//

import UIKit

///微博作者的用户信息的数据模型
@objcMembers
class StatusUserInfo: NSObject {

    //MARK:- 定义属性
    var screen_name : String?           //用户昵称
    var avatar_large : String?          //用户头像地址（大图），180×180像素
    var verified : Bool = false         //是否是微博认证用户，即加V用户
    var verified_type : Int = -1        //认证类型: -1:未认证
    var mbrank : Int = 0                //会员的等级
    
    
    //MARK:- 自定义构造函数
    init(dict: [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
}
