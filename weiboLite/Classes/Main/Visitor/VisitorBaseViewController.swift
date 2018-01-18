//
//  VisitorBaseViewController.swift
//  weiboLite
//
//  Created by Elvis on 2018/1/17.
//  Copyright © 2018年 Elvis. All rights reserved.
//

import UIKit

class VisitorBaseViewController: UITableViewController {
    
    //MARK: - 创建访客View
    lazy var visitorView = VisitorView.createVisitorView()
    
    //MARK: - 定义登录标识(默认未登录)
    var isLogin : Bool = false
    
    //系统回调函数, 如果未登录,回调visitorView访客视图
    override func loadView() {
        isLogin ? super.loadView() : setupVisitorView()
    }
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
       

    }
    
}

extension VisitorBaseViewController {
    private func setupVisitorView() {
        
        view = visitorView
    }
}
