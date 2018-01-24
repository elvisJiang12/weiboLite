//
//  NetworkTools.swift
//  11.使用cocoapods
//
//  Created by Elvis on 2018/1/23.
//  Copyright © 2018年 Elvis. All rights reserved.
//

import AFNetworking

///自定义枚举类型
enum RequestType : String {
    case GET
    case POST
}

class NetworkTools: AFHTTPSessionManager {
    
    ///创建一个单例
    //let是线程安全的: 即使多个线程同时访问, 也只会创建一次常量
    static let shareInstance : NetworkTools = {
        
        let tools = NetworkTools()
        
        //添加JSON序列化的格式
        tools.responseSerializer.acceptableContentTypes?.insert("text/html")
        //tools.responseSerializer.acceptableContentTypes?.insert("application/json")
        
        return tools
    }() //闭包

}


//MARK:- 封装请求方法
extension NetworkTools {
    
    func request(requestType: RequestType, urlString: String, parameters: [String: Any], finished: @escaping (_ result: Any?, _ error: Error?) -> ()) {
        
        ///定义成功的回调闭包
        let successBlock = { (task: URLSessionDataTask, result: Any?) in
            finished(result, nil)
        }
        ///定义失败的回调闭包
        let failureBlock = { (task: URLSessionDataTask?, error: Error) in
            finished(nil, error)
        }

        //发送网络请求
        if requestType == .GET {
            //GET请求
            self.get(urlString, parameters: parameters, progress: nil, success: successBlock, failure: failureBlock)
            
        } else if requestType == .POST {
            //POST请求
            self.post(urlString, parameters: parameters, progress: nil, success: successBlock, failure: failureBlock)
        }
    }
}


//MARK:- 请求AccessToken https://api.weibo.com/oauth2/access_token
extension NetworkTools {
    
    func loadAccessToken(code: String, finished: @escaping (_ result: [String : Any]?, _ error: Error?) -> ()) {
        //1.获取请求的URLString
        let urlString = "https://api.weibo.com/oauth2/access_token"
        
        //2.获取请求的参数
        let parameters = ["client_id" : app_key,
                          "client_secret" : app_secret,
                          "grant_type" : "authorization_code",
                          "code" : code,
                          "redirect_uri" : redirect_uri]
        
        //3.发送网络请求
        NetworkTools.shareInstance.request(requestType: .POST, urlString: urlString, parameters: parameters) { (result, error) in
            finished(result as? [String : Any], error)
        }
    }
}


//MARK:- 请求用户信息 https://api.weibo.com/2/users/show.json
extension NetworkTools {
    
    func loadUserInfo(access_token: String, uid: String, finished: @escaping (_ result: [String : Any]?, _ error: Error?) -> ()) {
        
        //1.获取请求的URLString
        let urlString = "https://api.weibo.com/2/users/show.json"
        
        //2.请求的参数
        let parameters = ["access_token" : access_token, "uid" : uid]
        
        //3.发送网络请求
        request(requestType: .GET, urlString: urlString, parameters: parameters) { (result, error) in
            finished(result as? [String : Any], error)
        }
    }
}
