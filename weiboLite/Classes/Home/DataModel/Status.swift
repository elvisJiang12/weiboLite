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
    var created_at : String?                //微博创建时间
    var mid : Int64 = 0                     //微博MID
    var text : String?                      //微博信息内容
    var source : String?                    //微博来源
    var userInfo : StatusUserInfo?          //微博作者的用户信息
    var pic_urls : [[String : String]]?     //微博的图片地址
    //var bmiddle_pic : String?               //微博图片的大图
    var retweeted_status : Status?          //转发的原微博
    
    //MARK:- 自定义构造函数
    init(dict: [String : Any]) {
        super.init()
        setValuesForKeys(dict)
        
        //微博作者的用户信息字典转模型
        if let userDict = dict["user"] as? [String : Any] {
            userInfo = StatusUserInfo.init(dict: userDict)
        }
        
        //转发的微博转成模型
        if let retweetedStatusDict = dict["retweeted_status"] as? [String : Any] {
            retweeted_status = Status.init(dict: retweetedStatusDict)
        }
        
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
}
