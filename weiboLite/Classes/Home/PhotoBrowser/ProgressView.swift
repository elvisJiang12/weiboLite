//
//  ProgressView.swift
//  weiboLite
//
//  Created by Elvis on 2018/2/10.
//  Copyright © 2018年 Elvis. All rights reserved.
//

import UIKit

class ProgressView: UIView {

    //MARK:- 定义属性
    var progress : CGFloat = 0 {
        didSet {
            //调用绘制方法
            DispatchQueue.main.async { //调用主线程
                self.setNeedsDisplay()
            }
        }
    }
    
    //MARK:- 重写drawRect方法
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        //准备贝塞尔曲线的参数
        let center = CGPoint(x: rect.width * 0.5, y: rect.height * 0.5)
        let radius = rect.width * 0.5 - 3
        let startAngle = CGFloat(-(Double.pi / 2))
        let endAngle = CGFloat(2 * Double.pi) * progress + startAngle
        
        //创建贝塞尔曲线
        let path = UIBezierPath.init(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        //绘制一条中心点到贝塞尔曲线的线
        path.addLine(to: center)
        path.close()//关闭路径
        
        UIColor.init(white: 1.0, alpha: 0.5).setFill()
        
        //开始绘制
        path.fill()
    }

}
