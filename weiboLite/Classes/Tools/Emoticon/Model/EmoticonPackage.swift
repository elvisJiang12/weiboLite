//
//  EmoticonPackage.swift
//  12.自定义表情键盘
//
//  Created by Elvis on 2018/2/3.
//  Copyright © 2018年 Elvis. All rights reserved.
//

import UIKit

class EmoticonPackage: NSObject {

    var emoticon : [Emoticon] = [Emoticon]()

    //重写init()方法
    init(id : String) {
        super.init()
        //最近分组
        if id == "" {
            addEmptyEmoticon(isRecentlyGroup: true)
            return
        }
        
        //根据id拼接表情资源包的路径
        let path = Bundle.main.path(forResource: "\(id)/info.plist", ofType: nil, inDirectory: "Emoticons.bundle")
        
        //读取plist文件中的数据
        let array = NSArray.init(contentsOfFile: path!) as! [[String : String]]
        
        //遍历数组中的字典, 把表情装入package数组中
        var index = 0
        for var dict in array {
            if let png = dict["png"] {
                dict["png"] = id + "/" + png
            }
            
            emoticon.append(Emoticon.init(dict: dict))
            index += 1
            
            //由于一页显示21个表情,所以在每20个表情后插入一个删除表情
            if index == Int(numverOfItemsInOnePage) - 1 {
                emoticon.append(Emoticon.init(isRemoveEmoticon: true))
                index = 0
            }
        }
        
        //设置空白表情
        self.addEmptyEmoticon(isRecentlyGroup: false)
    }
    
    ///设置空白表情
    private func addEmptyEmoticon(isRecentlyGroup : Bool) {
        let count = emoticon.count % Int(numverOfItemsInOnePage)
        
        //1.如果package里面的表情数正好是21的倍数, 则不需要添加空白的表情站位
        if count == 0 && !isRecentlyGroup {
            return
        }
        
        //2.如果package里面的表情数没有被21整除, 则需要添加(20-余数-1)个空白的表情,以及一个删除表情
        for _ in 0...(Int(numverOfItemsInOnePage) - 1 - count - 1) {
            emoticon.append(Emoticon.init(isEmptyEmoticon: true))
        }
        //空白表情的最后需再补一个删除表情
        emoticon.append(Emoticon.init(isRemoveEmoticon: true))
    }
}
