//
//  UIBarButtonItem-Extention.swift
//  weiboLite
//
//  Created by Elvis on 2018/1/18.
//  Copyright © 2018年 Elvis. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    ///"便利"构造函数(方法一)
//    convenience init(imageName: String) {
//        self.init()
//
//        let btn = UIButton()
//        btn.setImage(UIImage.init(named: imageName), for: .normal)
//        btn.setImage(UIImage.init(named: imageName + "_highlighted"), for: .highlighted)
//        btn.sizeToFit()
//
//        self.customView = btn
//    }
    
    ///"便利"构造函数(方法二)
    convenience init(imageName: String) {
        
        let btn = UIButton()
        btn.setImage(UIImage.init(named: imageName), for: .normal)
        btn.setImage(UIImage.init(named: imageName + "_highlighted"), for: .highlighted)
        btn.sizeToFit()
        
        self.init(customView: btn)
    }
    
}
