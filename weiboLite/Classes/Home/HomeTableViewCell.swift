//
//  HomeTableViewCell.swift
//  weiboLite
//
//  Created by Elvis on 2018/1/26.
//  Copyright © 2018年 Elvis. All rights reserved.
//

import UIKit
import SDWebImage

class HomeTableViewCell: UITableViewCell {

    //MARK:- 添加连线的属性
    @IBOutlet var iconView: UIImageView!
    @IBOutlet var verifiedView: UIImageView!
    @IBOutlet var nickNameLabel: UILabel!
    @IBOutlet var vipView: UIImageView!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var sourceLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    
    //MARK:- 自定义计算属性
    var status : StatusModelOpt? {
        didSet {
            //0.空值校验
            guard let status = status else {
                printLog("微博模型数据为空")
                return
            }
            
            //1.设置用户头像
            iconView.sd_setImage(with: status.profileURL) { (image : UIImage?, error : Error?, type : SDImageCacheType, url: URL?) in
                if error != nil {
                    printLog(error)
                    printLog(url)
                }
            }
            //设置图片的半径
            iconView.layer.cornerRadius = iconView.bounds.width * 0.5
            iconView.layer.masksToBounds = true
            
            //2.设置认证类型
            self.verifiedView.image = status.verified_Image
            
            //3.设置用户昵称
            nickNameLabel.text = status.statusOpt?.userInfo?.screen_name
            nickNameLabel.textColor = status.vip_Image == nil ? UIColor.black : UIColor.orange
            
            //4.设置会员等级
            vipView.image = status.vip_Image
            
            //5.设置发布时间
            timeLabel.text = status.createdTimeForDisplay
            
            //6.设置发布来源
            sourceLabel.text = status.souceForDisplay
            
            //7.设置微博正文
            contentLabel.text = status.statusOpt?.text
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    


}
