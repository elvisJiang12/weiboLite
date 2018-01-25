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
    
    var defaultViewController: UIViewController? {
        let isLogin = UserAccountTools.shareInstance.isLogin()
        
        if isLogin {
            return WelcomeViewController()
        } else {
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

