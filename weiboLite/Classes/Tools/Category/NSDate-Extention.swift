//
//  NSDate-Extention.swift
//  weiboLite
//
//  Created by Elvis on 2018/1/26.
//  Copyright © 2018年 Elvis. All rights reserved.
//

import Foundation

//MARK:- 扩展NSDate的类方法
extension NSDate {
    
    ///把String类型的时间, 转成想要的字符串
    class func createDateFromString(dateStr : String) -> String {
        
        //1.创建时间格式化对象
        let formater = DateFormatter()
        formater.dateFormat = "EEE MM-dd HH:mm:ss Z yyyy"
        formater.locale = Locale(identifier: "en")
        
        //2.将字符串的时间,转为Date类型
        guard let createdDate = formater.date(from: dateStr) else {
            printLog("微博的创建时间为空")
            return ""
        }
        
        //3.计算创建时间,至当前时间的时间差
        let interval = Int(Date().timeIntervalSince(createdDate))
        
        //4.对时间差进行逻辑处理
        //一分钟内
        if interval <= 60 {
            return "刚刚"
        }
        //一小时内
        if interval <= 60 * 60 {
            return "\(interval / 60)分钟前"
        }
        //一天之内
        if interval <= 60 * 60 * 24 {
            return "\(interval / (60 * 60))小时前"
        }
        //昨天
        let calendar = NSCalendar.current
        if calendar.isDateInYesterday(createdDate) {
            formater.dateFormat = "昨天 HH:mm"
            return formater.string(from: createdDate)
        }
        //一年之内
        let cmps = calendar.dateComponents([.year], from: createdDate, to: Date())
        printLog(cmps)
        if cmps.year! <= 1 {
            formater.dateFormat = "MM-dd HH:mm"
            return formater.string(from: createdDate)
        }
        //一年之外
        formater.dateFormat = "yyyy-MM-dd HH:mm"
        return formater.string(from: createdDate)
        
    }
}
