//
//  VisitorView.swift
//  weiboLite
//
//  Created by Elvis on 2018/1/17.
//  Copyright © 2018年 Elvis. All rights reserved.
//

import UIKit

class VisitorView: UIView {

    class func createVisitorView() -> VisitorView {
        
        //加载VisitorView.xib
        return Bundle.main.loadNibNamed("VisitorView", owner: self, options: nil)!.first as! VisitorView
        
    }

    
    
    @IBOutlet var rotationView: UIImageView!
    @IBOutlet var iconView: UIImageView!
    @IBOutlet var tipLabel: UILabel!
    @IBOutlet var registerBtn: UIButton!
    @IBOutlet var loginBtn: UIButton!
    
    //自定义函数
    func setupVisitorViewInfo(iconName: String, text: String) {
        iconView.image = UIImage.init(named: iconName)
        tipLabel.text = text
        rotationView.isHidden = true
        
    }
    
    //创建旋转动画
    func addRotationAnim() {
        
        //1.创建动画
        let rotationAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        
        //2.设置动画的属性
        rotationAnim.fromValue = 0
        rotationAnim.toValue = Double.pi * 2
        rotationAnim.repeatCount = MAXFLOAT
        rotationAnim.duration = 8
        rotationAnim.isRemovedOnCompletion = false
        
        //3.将动画添加到layer中
        rotationView.layer.add(rotationAnim, forKey: nil)
        
    }
    
    
    
    
    
    
}
