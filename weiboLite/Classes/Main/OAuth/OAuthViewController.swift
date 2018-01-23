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
        webView.loadRequest(URLRequest.init(url: URL(string: "https://api.weibo.com/oauth2/authorize?client_id=\(app_key)&redirect_uri=\(redirect_uri)")!))
            
        

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
    
}

//MARK:- 事件监听
extension OAuthViewController {
    
    @objc private func closeItemClick() {
        //关闭授权登录view
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func fillItemClick() {
        //自动填充登录的用户名和密码
        let jsCode = "document.getElementById('userId').value='yehshow@hotmail.com';document.getElementById('passwd').value='iosxuexi';"
        //执行JavaScript代码
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

}
