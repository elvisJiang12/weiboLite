//
//  StatusModelTools.swift
//  weiboLite
//
//  Created by Elvis on 2018/1/26.
//  Copyright © 2018年 Elvis. All rights reserved.
//

import UIKit

///Status模型再次封装为:视图模型ViewModel
class StatusModelOpt: NSObject {
    
    //MARK:- 定义属性
    var statusOpt : Status?
    
    //MARK:- 需逻辑处理的属性
    var createdTimeForDisplay : String?     //供界面展示的"微博创建时间"
    var souceForDisplay : String?           //供界面展示的"微博来源"
    var verified_Image : UIImage?           //认证类型对应的Image
    var vip_Image : UIImage?                //会员等级对应的Image
    var profileURL : URL?                   //用户头像的URL
    var picURLs : [URL] = [URL]()           //微博的图片地址
    
    //MARK:- 构造函数
    init(statusOpt : Status) {
        self.statusOpt = statusOpt
        
        //处理供界面展示的"微博创建时间"
        if let created_at = statusOpt.created_at, created_at != "" {
            createdTimeForDisplay = NSDate.createDateFromString(dateStr: created_at)
        }
        
        //处理供界面展示的"微博来源"
        //1.nil值校验
        if let source = statusOpt.source, source != "" {
            //2.对原始字符串进行处理
            //2.1获取字符串起始的位置和需要截取的长度
            let startIndex = (source as NSString).range(of: "nofollow\">").location + 10
            let length = (source as NSString).range(of: "</a>").location - startIndex
            //2.2截取字符串
            souceForDisplay = "来自" + (source as NSString).substring(with: NSRange(location: startIndex, length: length))
        } else {
            souceForDisplay = "来自未知设备"
        }
        
        //处理认证类型对应的Image
        switch statusOpt.userInfo?.verified_type ?? -1 {
        case 0:          //0:个人认证
            verified_Image = UIImage(named: "avatar_vip")
        case 1, 2, 3, 5:    //1,2,3,5:企业认证
            verified_Image = UIImage(named: "avatar_enterprise_vip")
        case 220:        //220:达人认证
            verified_Image = UIImage(named: "avatar_grassroot")
        default:
            break
        }
        
        //处理会员等级对应的Image
        let mbrank = statusOpt.userInfo?.mbrank ?? 0
        if mbrank == 0 {
            vip_Image = UIImage(named: "")
        } else if mbrank > 0 && mbrank <= 6 {
            vip_Image = UIImage(named: "common_icon_membership_level\(mbrank)")
        } else {
            //!!!!!缺少等级7的图片资源
            vip_Image = UIImage(named: "common_icon_membership_level6")
        }
        
        //处理用户头像的URL
        let profileURLString = statusOpt.userInfo?.profile_image_url ?? ""
        profileURL = URL.init(string: profileURLString)
        
        //处理微博的配图地址, String -> URL
        //如果微博的图片数量为0, 则取转发微博的图片
        let tempURLDict = statusOpt.pic_urls?.count != 0 ? statusOpt.pic_urls : statusOpt.retweeted_status?.pic_urls
        
        if let picURLDictArray = tempURLDict {
            for picURLDict in picURLDictArray {
                //遍历数组, 通过key = thumbnail_pic获取图片地址的String
                guard let picURLString = picURLDict["thumbnail_pic"] else {
                    continue
                }
                //URL地址替换成高清图的URL
                let picURLHD = (picURLString as NSString).replacingOccurrences(of: "thumbnail", with: "bmiddle")
                picURLs.append(URL.init(string: picURLHD)!)
            }
        }
        
    }

}
