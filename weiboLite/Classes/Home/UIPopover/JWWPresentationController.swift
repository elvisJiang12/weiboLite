//
//  JWWPresentationController.swift
//  weiboLite
//
//  Created by Elvis on 2018/1/18.
//  Copyright © 2018年 Elvis. All rights reserved.
//

import UIKit

///自定义弹出窗口
class JWWPresentationController: UIPresentationController {
    
    //MARK:- 设置懒加载属性
    private lazy var coverView: UIView = UIView()
    
    
    //重写layout布局的方法, 自定义被弹出的view
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
        //设置弹出view的尺寸
        let presentViewW : CGFloat = 180
        let presentViewH : CGFloat = 250
        let presentViewX : CGFloat = (containerView!.frame.size.width - presentViewW) * 0.5
        let presentViewY : CGFloat = 52
        
        
        presentedView?.frame = CGRect(x: presentViewX, y: presentViewY, width: presentViewW, height: presentViewH)
        
        //弹出view后, 对之前的UI添加遮盖的蒙版
        setupCoverView()
    }

}

//MARK:- 设置UI界面相关
extension JWWPresentationController {
    
    ///弹出view后, 对之前的UI添加遮盖的蒙版
    private func setupCoverView() {
        
        //设置蒙版的属性
        coverView.backgroundColor = UIColor(white: 0.8, alpha: 0.0)
        coverView.frame = containerView!.bounds
        
        //添加蒙版至containerView中, 并且不能遮盖弹出的view
        containerView!.insertSubview(coverView, belowSubview: presentedView!)
        //containerView!.insertSubview(coverView, at: 0)
        
        //添加控件的点击手势,监听蒙版的点击
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(dismissCoverView))
        tapGes.numberOfTouchesRequired = 1    //手指数
        tapGes.numberOfTapsRequired = 1       //点击数
        coverView.addGestureRecognizer(tapGes)
        
    }
    
}

//MARK:- 事件监听
extension JWWPresentationController {
    
    ///监听弹
    @objc private func dismissCoverView() {
        
        presentedViewController.dismiss(animated: true) {
            printLog("关闭弹出窗口:presentedView")
        }
        
    }

}
