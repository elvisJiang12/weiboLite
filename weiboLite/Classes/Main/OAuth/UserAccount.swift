//
//  UserAccount.swift
//  weiboLite
//
//  Created by Elvis on 2018/1/24.
//  Copyright © 2018年 Elvis. All rights reserved.
//

import UIKit

@objcMembers //代表所有属性都@objc

class UserAccount: NSObject {
    
    //MARK:- 定义属性
    ///用户授权的唯一票据，用于调用微博的开放接口，同时也是第三方应用验证微博用户登录的唯一票据，第三方应用应该用该票据和自己应用内的用户建立唯一影射关系，来识别登录状态，不能使用本返回值里的UID字段来做登录识别。
    @objc var access_token : String?
    ///access_token的生命周期，单位是秒数。
    var expires_in : TimeInterval = 0
    ///授权用户的UID，本字段只是为了方便开发者，减少一次user/show接口调用而返回的，第三方应用不能用此字段作为用户登录状态的识别，只有access_token才是用户授权的唯一票据。
    var uid : String?
    ///自定义一个计算属性
    var expires_date : Date {
        return Date(timeIntervalSinceNow: expires_in)
    }
    ///用户昵称
    var screen_name : String?
    ///用户头像地址（大图），180×180像素
    var avatar_large : String?
    
    //MARK:- 自定义构造函数
    init(dict: [String : Any]) {
        super.init()
        
        //利用KVC赋值
        setValuesForKeys(dict)
    }
    
    //重写空的此方法, 避免数据源中包含类中未定义的key
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    //重写description属性
    override var description : String {
        return dictionaryWithValues(forKeys: ["access_token", "expires_date", "uid", "screen_name", "avatar_large"]).description
    }
    

}
