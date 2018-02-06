//
//  DiscoverViewController.swift
//  weiboLite
//
//  Created by Elvis on 2018/1/17.
//  Copyright © 2018年 Elvis. All rights reserved.
//

import UIKit

class DiscoverViewController: VisitorBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //设置访客视图的内容
        visitorView.setupVisitorViewInfo(iconName: "visitordiscover_image_message",
                                         text: "登录后，别人评论你的微博，给你发消息，都会在这里收到通知")
    }


}
