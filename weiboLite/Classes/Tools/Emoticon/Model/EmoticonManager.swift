//
//  EmoticonManager.swift
//  12.自定义表情键盘
//
//  Created by Elvis on 2018/2/3.
//  Copyright © 2018年 Elvis. All rights reserved.
//

import UIKit

class EmoticonManager: NSObject {

    var packages = [EmoticonPackage]()
    
    //重写init()方法
    override init() {
        //1.添加最近表情
        packages.append(EmoticonPackage(id: ""))
        //2.添加默认表情
        packages.append(EmoticonPackage(id: "com.sina.default"))
        //3.添加emoji表情
        packages.append(EmoticonPackage(id: "com.apple.emoji"))
        //4.添加浪小花表情
        packages.append(EmoticonPackage(id: "com.sina.lxh"))
    }
}
