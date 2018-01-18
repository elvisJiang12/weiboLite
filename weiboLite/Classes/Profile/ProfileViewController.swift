//
//  ProfileViewController.swift
//  weiboLite
//
//  Created by Elvis on 2018/1/17.
//  Copyright © 2018年 Elvis. All rights reserved.
//

import UIKit

class ProfileViewController: VisitorBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置访客视图的内容
        visitorView.setupVisitorViewInfo(iconName: "visitordiscover_image_profile",
                                         text: "登录后，你的微博、相册、个人资料会显示在这里，展示给别人")

    }


}
