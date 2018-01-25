//
//  UserAccountTools.swift
//  weiboLite
//
//  Created by Elvis on 2018/1/25.
//  Copyright © 2018年 Elvis. All rights reserved.
//

import UIKit

class UserAccountTools { //无需继承任何类, 更轻量级
    
    //MARK:- 将类设计为单例(只会创建一次,调用一次init()方法)
    static let shareInstance : UserAccountTools = UserAccountTools()
    
    var userInfo : UserAccount?
    //MARK:- 定义一个计算属性, 获取沙盒路径
    var filePath : String {
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first! + "/userInfo.plist"
        printLog(path)
        return path
    }
    
    
    //重写init()方法
    init() {
        //从沙盒中读取归档的信息
        userInfo = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? UserAccount
    }

}

//MARK:- 工具类的扩展方法
extension UserAccountTools {
    
    ///判断是否可以使用accessToken直接登录
    func isLogin() -> Bool {
        //如果读取不到用户数据,返回未登录
        if userInfo == nil {
            return false
        }
        //如果token过期, 返回未登录
        guard let expiresDate = userInfo?.expires_date else {
            return false
        }
        //如果未过期, 直接登录
        return Date().compare(expiresDate) == ComparisonResult.orderedAscending
    }
    
    ///获取用户的昵称
    func getNickName() -> String {
        guard let nickName = userInfo?.screen_name else {
            printLog("未获取到用户的昵称")
            return ""
        }
        return nickName
    }
    
}
