//
//  UIButton-Extension.swift
//  weiboLite
//
//  Created by Elvis on 2018/1/17.
//  Copyright © 2018年 Elvis. All rights reserved.
//

import UIKit

//MARK:- 扩展UIButton的类方法
extension UIButton {
    
    ///扩展类方法: class func
    class func createButton(imageName: String, bgImageName: String) -> UIButton {
        
        let btn = UIButton()
        
        btn.setBackgroundImage(UIImage.init(named: bgImageName), for: .normal)
        btn.setBackgroundImage(UIImage.init(named: bgImageName + "_highlighted"), for: .highlighted)
        
        btn.setImage(UIImage.init(named: imageName), for: .normal)
        btn.setImage(UIImage.init(named: imageName + "_highlighted"), for: .highlighted)
        
        //设置发布按钮的frame
        btn.sizeToFit() //根据图片的大小设置button尺寸
        
        return btn
    }
    
    
    /*"便利"构造函数的特点:
        1.便利构造函数通常都是写在extension扩展中
        2.便利构造函数init前需要加convenience
        3.在便利构造函数中必须明确调用self.init()
     */
    ///(推荐)扩展"便利"构造函数: convenience init()
    convenience init(imageName: String, bgImageName: String) {
        
        self.init()
        
        setBackgroundImage(UIImage.init(named: bgImageName), for: .normal)
        setBackgroundImage(UIImage.init(named: bgImageName + "_highlighted"), for: .highlighted)
        
        setImage(UIImage.init(named: imageName), for: .normal)
        setImage(UIImage.init(named: imageName + "_highlighted"), for: .highlighted)
        
        sizeToFit() //根据图片的大小设置button尺寸
    }
    
    
    convenience init(bgClolor: UIColor, fontSize: CGFloat, title : String) {
        
        self.init()
        
        setTitle(title, for: .normal)
        backgroundColor = bgClolor
        titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
    }
    
}
