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
    var isLogin : Bool = false
    
    //系统回调函数
    override func loadView() {
        
        //从沙盒中读取用户的归档信息
        let filePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first! + "/userInfo.plist"
        //解档:读取用户信息
        let userInfo = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? UserAccount
        if let userInfo = userInfo {
            //对比accessToken过期日期, 和当前的日期
            if let expiresDate = userInfo.expires_date {
                //判断当前是否过期, 如果未过期直接登录
                isLogin = Date().compare(expiresDate) == ComparisonResult.orderedAscending
            }
        }
        
        //判断显示哪一个view,如果未登录,回调visitorView访客视图
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
        
        //1.创建授权登录的控制器
        let oauthVc = OAuthViewController()
        
        //2.包装导航控制器
        let oauthNav = UINavigationController(rootViewController: oauthVc)
        
        //3.弹出控制器,Presents a view controller modally
        present(oauthNav, animated: true, completion: nil)
    }
    
    
}
