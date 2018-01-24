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

//MARK:- 请求AccessToken
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
            let userAccessToken = UserAccessToken.init(dict: dict)
            
            printLog(userAccessToken)
        }
    }
    
}