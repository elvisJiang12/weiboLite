//
//  WelcomeViewController.swift
//  weiboLite
//
//  Created by Elvis on 2018/1/25.
//  Copyright © 2018年 Elvis. All rights reserved.
//

import UIKit
import SDWebImage

class WelcomeViewController: UIViewController {
    
    //拖线约束, 作为对象的属性
    @IBOutlet var iconViewBottomCons: NSLayoutConstraint!
    @IBOutlet var iconView: UIImageView!
    @IBOutlet var expiresLabel: UILabel!
    @IBOutlet var textLabel: UILabel!
    
    //MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()

        //0.设置用户头像
        let profileURLString = UserAccountTools.shareInstance.userInfo?.avatar_large
        //?? 表示如果??前面的可选类型为nil, 那么直接使用??后面的值
        let url = URL.init(string: profileURLString ?? "")
        //加载远程图片
        iconView.sd_setImage(with: url) { (image : UIImage?, error : Error?, type : SDImageCacheType, url: URL?) in
            if error != nil {
                printLog(error)
                printLog(url)
            }
            
        }
        //设置图片的半径
        iconView.layer.cornerRadius = iconView.bounds.width * 0.5
        iconView.layer.masksToBounds = true
        
        //设置欢迎的文字
        let nickName = UserAccountTools.shareInstance.userInfo?.screen_name ?? ""
        textLabel.text = "\(nickName), 欢迎回来"
        
        //提示登录过期的日期
        guard let expires_date = UserAccountTools.shareInstance.userInfo?.expires_date else {
            return
        }
        let formator = DateFormatter()
        formator.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let a = formator.string(from: expires_date)
        printLog(a)
        expiresLabel.text = "授权将在\(a)过期"
        
        
        //1.改变约束的值
        iconViewBottomCons.constant = UIScreen.main.bounds.height * 0.65
        
        //2.执行动画
        //usingSpringWithDamping: 阻力系数(0 ~ 1), 系数越大,弹动的效果越不明显
        //initialSpringVelocity: 动画的初始化速度
        //options: [], 枚举型的值,如果不想传任何值,写[]
        UIView.animate(withDuration: 3.0, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 5.0, options: [], animations: {
            self.view.layoutIfNeeded()
        }) { (_) in
            //动画完成后, 设置storyBoard中的main作为根控制器
            UIApplication.shared.keyWindow?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        }
        
    }


}
