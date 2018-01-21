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
    
    //MARK: - 登录标识(默认未登录)
    var isLogin : Bool = true
    
    //系统回调函数, 如果未登录,回调visitorView访客视图
    override func loadView() {
        isLogin ? super.loadView() : setupVisitorView()
    }
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItems()
       

    }
    
}

//MARK: - 设置访客视图的UI界面
extension VisitorBaseViewController {
    
    ///设置访客视图
    private func setupVisitorView() {
        
        view = visitorView
        
        //监听点击"注册"按钮
        visitorView.registerBtn.addTarget(self,
                                          action: #selector(registerbtnClick),
                                          for: .touchUpInside)
        //监听点击"登录"按钮
        visitorView.loginBtn.addTarget(self,
                                          action: #selector(loginBtnClick),
                                          for: .touchUpInside)
    }
    
    ///设置导航栏的Item按钮
    private func setupNavigationItems() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(registerbtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(loginBtnClick))
    }
    
    
}

//MARK: - 事件监听
extension VisitorBaseViewController {
    
    ///监听点击"注册"按钮
    @objc private func registerbtnClick() {
        printLog("registerbtnClick")
    }
    
    ///监听点击"登录"按钮
    @objc private func loginBtnClick() {
        printLog("loginBtnClick")
    }
    
    
}
