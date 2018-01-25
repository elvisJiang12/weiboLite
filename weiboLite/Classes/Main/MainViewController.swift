//
//  MainViewController.swift
//  weiboLite
//
//  Created by Elvis on 2018/1/16.
//  Copyright © 2018年 Elvis. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    
    //MARK: - 懒加载创建数据
    lazy var composeBtn : UIButton = UIButton(imageName: "tabbar_compose_icon_add",
                                              bgImageName: "tabbar_compose_button")
    lazy var imageNames = ["tabbar_home",
                           "tabbar_message_center",
                           "",
                           "tabbar_discover",
                           "tabbar_profile"]

    //MARK:- 系统回调的函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupComposeBtn()
        
        
    
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /*已通过storyboard直接设置
        setupTabbarItems()
         */
        
    }


}

//MARK: - 设置Main界面的UI
extension MainViewController {
    
    //设置发布按钮
    private func setupComposeBtn() {

        //设置发布按钮"[+]"的位置
        composeBtn.center = CGPoint(x: tabBar.center.x, y: tabBar.bounds.size.height * 0.5)
        
        //将composeBtn添加到tabBar中
        tabBar.addSubview(composeBtn)
        
        //监听发布按钮的点击操作
        //Selector的两种写法: 1>#selector(composeBtnClick);2>#selector(MainViewController.composeBtnClick)
        composeBtn.addTarget(self, action: #selector(MainViewController.composeBtnClick), for: .touchUpInside)
    }
    
    //设置tabbar的按钮被选中时的highlighted图片
    private func setupTabbarItems() {
        //遍历tabBar的所有Item
        for i in 0..<tabBar.items!.count {
            //获取当前的Item
            let item = tabBar.items![i]
            
            //下标为2的Item, 禁止和用户交互
            if i == 2 {
                item.isEnabled = false
                continue
            }
            
            //设置其他Item被选中时的highlighted图片
            item.selectedImage = UIImage.init(named: imageNames[i] + "_highlighted")
        }
    }
    
}

//MARK: - 事件监听
extension MainViewController {
    
    @objc private func composeBtnClick() {
        printLog("用户点击了composebtn")
    }
    
    
    
    
}
