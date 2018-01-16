//
//  MainViewController.swift
//  weiboLite
//
//  Created by Elvis on 2018/1/16.
//  Copyright © 2018年 Elvis. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    
    lazy var composeBtn : UIButton = UIButton()
    lazy var imageNames = ["tabbar_home",
                           "tabbar_message_center",
                           "",
                           "tabbar_discover",
                           "tabbar_profile"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupComposeBtn()
    
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupTabbarItems()
        
    }


}

//MARK: - 设置Main界面的UI
extension MainViewController {
    
    //设置发布按钮
    private func setupComposeBtn() {
        //设置发布按钮的属性
        composeBtn.setBackgroundImage(UIImage.init(named: "tabbar_compose_button"), for: .normal)
        composeBtn.setBackgroundImage(UIImage.init(named: "tabbar_compose_button_highlighted"), for: .highlighted)
        
        composeBtn.setImage(UIImage.init(named: "tabbar_compose_icon_add"), for: .normal)
        composeBtn.setImage(UIImage.init(named: "tabbar_compose_icon_add_highlighted"), for: .highlighted)
        
        //设置发布按钮的frame
        composeBtn.sizeToFit() //根据图片的大小设置尺寸
        composeBtn.center = CGPoint(x: tabBar.center.x, y: tabBar.bounds.size.height * 0.5)
        
        //将composeBtn添加到tabBar中
        tabBar.addSubview(composeBtn)
    }
    
    //设置tabbar的按钮
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
