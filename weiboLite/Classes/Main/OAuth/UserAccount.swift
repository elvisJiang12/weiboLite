//  用户信息的模型
//  UserAccount.swift
//  weiboLite
//
//  Created by Elvis on 2018/1/24.
//  Copyright © 2018年 Elvis. All rights reserved.
//

import UIKit

@objcMembers //代表所有属性都@objc

class UserAccount: NSObject,NSCoding {
    
    //MARK:- 归档&解档
    //归档
    func encode(with aCoder: NSCoder) {
        aCoder.encode(access_token, forKey: "access_token")
        aCoder.encode(expires_date, forKey: "expires_date")
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(screen_name, forKey: "screen_name")
        aCoder.encode(avatar_large, forKey: "avatar_large")
    }
    //解档
    required init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObject(forKey: "access_token") as? String
        expires_date = aDecoder.decodeObject(forKey: "expires_date") as? Date
        uid = aDecoder.decodeObject(forKey: "uid") as? String
        screen_name = aDecoder.decodeObject(forKey: "screen_name") as? String
        avatar_large = aDecoder.decodeObject(forKey: "avatar_large") as? String
    }
    
    
    //MARK:- 定义属性
    ///用户授权的唯一票据，用于调用微博的开放接口，同时也是第三方应用验证微博用户登录的唯一票据，第三方应用应该用该票据和自己应用内的用户建立唯一影射关系，来识别登录状态，不能使用本返回值里的UID字段来做登录识别。
    @objc var access_token : String?
    ///access_token的生命周期，单位是秒数。
    
    var expires_in : TimeInterval = 0.0 {
        didSet{ //属性监听器
            expires_date = Date(timeIntervalSinceNow: expires_in)
        }
    }
    ///自定义一个属性: access_token的过期日期
    var expires_date : Date?
    
    ///授权用户的UID
    var uid : String?
    
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


