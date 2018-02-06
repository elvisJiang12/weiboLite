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
        tools.responseSerializer.acceptableContentTypes?.insert("application/json")
        
        return tools
    }() //闭包

}


//MARK:- 封装请求方法
extension NetworkTools {
    ///发送http请求(支持的类型:GET/POST)
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
    ///请求AccessToken
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
    ///请求用户信息
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


//MARK:- 获取当前登录用户及其所关注用户的最新微博 https://api.weibo.com/2/statuses/home_timeline.json
extension NetworkTools {
    ///获取当前登录用户及其所关注用户的最新微博
    func loadStatuses(since_id: Int64, max_id: Int64, finished: @escaping (_ result: [[String : Any]]?, _ error: Error?) -> ()) {
        //1.获取请求的URLString
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        
        //2.请求的参数
        let parameters: [String : Any] = ["access_token" : (UserAccountTools.shareInstance.userInfo?.access_token)!,
                                          "since_id" : since_id, "max_id" : max_id]
        
        //3.发送网络请求
        request(requestType: .GET, urlString: urlString, parameters: parameters) { (result,error) in
            guard let statusesDict = result as? [String : Any] else {
                printLog("未获取到用户的微博数据")
                return
            }
            //在返回结果的大字典中,通过key = "statuses", 获取并返回用户的微博数组
            finished(statusesDict["statuses"] as? [[String : Any]], error)
        }
    }

}


//MARK:- 第三方分享一条链接到微博 https://api.weibo.com/2/statuses/share.json
extension NetworkTools {
    ///用户发送微博
    func sendStatus(statusText : String, isSuccess : @escaping (_ isSuccess : Bool)->()) {
        //1.获取请求的URLString
        let urlString = "https://api.weibo.com/2/statuses/share.json"
        
        //2.请求的参数
        let parameters: [String : Any] = ["access_token" : (UserAccountTools.shareInstance.userInfo?.access_token)!, "status" : statusText]
        
        //3.发送网络请求
        request(requestType: .POST, urlString: urlString, parameters: parameters) { (result, error) in
            if result != nil {
                isSuccess(true)
            } else {
                isSuccess(false)
                printLog(error)
            }
        }
    }


}
