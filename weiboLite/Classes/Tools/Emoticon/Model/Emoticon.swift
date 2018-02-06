//
//  Emoticon.swift
//  12.自定义表情键盘
//
//  Created by Elvis on 2018/2/3.
//  Copyright © 2018年 Elvis. All rights reserved.
//

import UIKit

@objcMembers
class Emoticon: NSObject {

    //MARK:- 定义属性
    var chs : String?       //表情对应的文字
    var png : String? {     //表情对应的图片名
        didSet {
            guard let png = png else {
                print("未获取到表情的图片")
                return
            }
            pngPath = Bundle.main.bundlePath + "/Emoticons.bundle/" + png
        }
    }
    var code : String? {     //emoji的code
        didSet {
            guard let code = code else {
                print("未获取到emoji表情的code")
                return
            }
            
            //1.创建扫描器
            let scanner = Scanner.init(string: code)
            //2.扫描code中的值
            var value : UInt32 = 0
            scanner.scanHexInt32(&value)
            //3.将扫描的值转成字符
            let c = Character(Unicode.Scalar(value)!)
            //4.将字符转成字符串
            emojiCode = String(c)
        }
    }
    
    //MARK:- 处理后的属性
    var pngPath : String?
    var emojiCode : String?
    var isRemoveEmoticon = false
    var isEmptyEmoticon = false
    
    //MARK:- 自定义构造函数
    init(dict : [String : String]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    ///创建删除表情的构造函数
    init(isRemoveEmoticon : Bool) {
        self.isRemoveEmoticon = isRemoveEmoticon
    }
    
    ///创建空白表情的构造函数
    init(isEmptyEmoticon : Bool) {
        self.isEmptyEmoticon = isEmptyEmoticon
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }
    
    //重写description属性
    override var description: String {
        return dictionaryWithValues(forKeys: ["emojiCode", "pngPath", "chs"]).description
    }
    
}
