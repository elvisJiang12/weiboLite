//
//  HomeViewController.swift
//  weiboLite
//
//  Created by Elvis on 2018/1/17.
//  Copyright © 2018年 Elvis. All rights reserved.
//

import UIKit

class HomeViewController: VisitorBaseViewController {
    
    //MARK:- 设置懒加载数据
    private lazy var titleBtn = TitleButton()
    private lazy var popAnimator = JWWPopoverAnimator()
    

    //MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if !isLogin {
            printLog(isLogin)
            //首页未登录时的访客视图, 添加旋转动画
            visitorView.addRotationAnim()
            
            return //不执行后面的代码
        }
        
        
        //设置导航栏内容
        setupNavigationBar()
    }


}
//MARK: - 设置"首页"的UI界面
extension HomeViewController {
    
    //设置导航栏UI
    private func setupNavigationBar() {
        //设置左侧的Item
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(imageName: "navigationbar_friendattention")
        
        //设置右侧的Item
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(imageName: "navigationbar_pop")
        
        //设置中间的titleView
        titleBtn.setTitle("暂定微博名", for: .normal)
        navigationItem.titleView = titleBtn
        
        //监听titleButton的点击
        titleBtn.addTarget(self, action: #selector(titleBtnClick), for: .touchUpInside)
    }
    
}

//MARK: - 监听事件
extension HomeViewController {
    
    ///监听titleButton的点击
    @objc private func titleBtnClick(titleBtn: TitleButton) {
        
        //设置按钮状态
        titleBtn.isSelected = !titleBtn.isSelected
        
        //1.创建弹出的控制器
        let popoverVc = PopoverViewController()
        //2.设置控制器的弹出样式, modalPresentationStyle.custom表示弹出后,以前的view不删除
        popoverVc.modalPresentationStyle = .custom
        //3.设置转场动画的代理
        popoverVc.transitioningDelegate = self.popAnimator
        
        //弹出控制器
        present(popoverVc, animated: true, completion: nil)
        
    }
    
    
}

