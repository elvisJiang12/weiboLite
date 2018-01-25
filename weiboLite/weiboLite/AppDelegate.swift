//
//  AppDelegate.swift
//  weiboLite
//
//  Created by Elvis on 2018/1/16.
//  Copyright © 2018年 Elvis. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    //设置默认的View
    var defaultViewController: UIViewController? {
        let isLogin = UserAccountTools.shareInstance.isLogin()
        //如果用户登录,则显示欢迎界面及动画
        if isLogin {
            return WelcomeViewController()
        } else {
            //如果用户未登录, 则进入storyBoard主界面引导用户授权登录
            return UIStoryboard.init(name: "Main", bundle: nil).instantiateInitialViewController()
        }
    }
    


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //设置全局UITabbar的颜色
        UITabBar.appearance().tintColor = UIColor.orange
        //设置全局UINavigationBar的颜色
        UINavigationBar.appearance().tintColor = UIColor.orange
        
        //自定义创建程序启动的主界面
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = defaultViewController
        window?.makeKeyAndVisible()
        
        
        return true
    }


}

///自定义Log
func printLog <T> (_ message : T,
                 file : String = #file,
                 funcName : String = #function,
                 lineNum : Int = #line) {
    
    let fileName = (file as NSString).lastPathComponent
    
    print("自定义log: ClassName:\(fileName)--->funcName:\(funcName)--->line:\(lineNum)--->\(message)")
    
}

