//
//  OAuthViewController.swift
//  weiboLite
//
//  Created by Elvis on 2018/1/23.
//  Copyright © 2018年 Elvis. All rights reserved.
//

import UIKit
import SVProgressHUD

class OAuthViewController: UIViewController {
    
    @IBOutlet var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //设置授权登录界面的UI
        setupNavigationBar()
        
        //加载授权登录界面
        loadPage()
        

    }


}


//MARK:- 设置UI界面相关
extension OAuthViewController {
    
    private func setupNavigationBar() {
        //1.设置左侧的item
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(OAuthViewController.closeItemClick))
        
        //2.设置右侧的item
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "自动填充", style: .plain, target: self, action: #selector(OAuthViewController.fillItemClick))
        
        //3.设置中间的标题
        navigationItem.title = "授权登录"
    }
    
    ///加载授权登录页面
    private func loadPage() {
        
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(app_key)&redirect_uri=\(redirect_uri)"
        
        guard let url = URL.init(string: urlString) else {
            return
        }
        
        //创建urlRequest对象
        let request = URLRequest.init(url: url)
        
        //加载request
        webView.loadRequest(request)
    }
    
}

//MARK:- 事件监听
extension OAuthViewController {
    
    @objc private func closeItemClick() {
        //关闭授权登录view
        self.dismiss(animated: true, completion: nil)
    }
    
    //自动填充登录的用户名和密码
    @objc private func fillItemClick() {
        
        //书写javaScript代码
        let jsCode = "document.getElementById('userId').value='yehshow@hotmail.com';document.getElementById('passwd').value='iosxuexi';"
        //webView执行js代码
        webView.stringByEvaluatingJavaScript(from: jsCode)
    }

}


//MARK:- webView的代理方法
extension OAuthViewController : UIWebViewDelegate {
    
    //webView开始加载网页
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    //webView完成加载
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    //webView加载失败
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        SVProgressHUD.dismiss()
    }
    
    //当准备加载某个页面时,会调用此方法
    //返回true: 继续加载,   返回false: 停止加载
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        //获取加载网页的url
        guard let url = request.url else {
            return true
        }
        
        //url转为String类型
        let urlString = url.absoluteString
        //判断urlString中是否包含"code="
        guard urlString.contains("code=") else {
            return true
        }
        
        //截取code
        let code = urlString.components(separatedBy: "code=").last!
        
        //获取accessToken
        loadAccessToken(code: code)
        
        //获取到code后, 不需要再继续加载网页
        return false
    }

}

//MARK:- 请求AccessToken https://api.weibo.com/oauth2/access_token
extension OAuthViewController {
    private func loadAccessToken(code: String) {
        NetworkTools.shareInstance.loadAccessToken(code: code) { (result, error) in
            
            //error校验
            if error != nil {
                printLog(error)
                return
            }
            
            //获取授权数据
            guard let dict = result else {
                printLog("没有获取到授权的用户数据")
                return
            }
            
            //将字典转为UserAccount模型
            let userInfo = UserAccount.init(dict: dict)
            
            //请求用户的信息
            self.loadUserInfo(userInfo: userInfo)
        }
    }
    
}

//MARK:- 请求用户信息 https://api.weibo.com/2/users/show.json
extension OAuthViewController {
    private func loadUserInfo(userInfo : UserAccount) {
        
        //参数的校验
        guard let access_token = userInfo.access_token else {
            printLog("token获取失败")
            return
        }
        guard let uid = userInfo.uid else {
            printLog("uid获取失败")
            return
        }
        
        //发送网络请求
        NetworkTools.shareInstance.loadUserInfo(access_token: access_token, uid: uid) { (result, error) in
            //error校验
            if error != nil {
                printLog(error)
                return
            }
            
            //获取用户信息
            guard let infoDict = result else {
                printLog("没有获取到userInfo")
                return
            }
            
            //存储数据到模型, 取出字典中的昵称和用户头像地址, 进行保存
            userInfo.screen_name = infoDict["screen_name"] as? String
            userInfo.avatar_large = infoDict["avatar_large"] as? String
            
            //对象保存至文件
            let filePath = UserAccountTools.shareInstance.filePath
            NSKeyedArchiver.archiveRootObject(userInfo, toFile: filePath)
            
            //把userInfo对象的数据设置到单例中
            printLog(UserAccountTools.shareInstance.userInfo) //单例为空
            UserAccountTools.shareInstance.userInfo = userInfo
            printLog(UserAccountTools.shareInstance.userInfo) //设置后才有值
            
            
            //退出授权登录的控制器界面
            self.dismiss(animated: false, completion: {
                //创建并显示"欢迎"界面
                UIApplication.shared.keyWindow?.rootViewController = WelcomeViewController()
            })
            
        }
    }
}
