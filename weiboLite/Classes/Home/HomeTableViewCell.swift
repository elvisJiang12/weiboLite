//
//  HomeTableViewCell.swift
//  weiboLite
//
//  Created by Elvis on 2018/1/26.
//  Copyright © 2018年 Elvis. All rights reserved.
//

import UIKit
import SDWebImage

///边缘间隔
let edgeMargin : CGFloat = 15
///图片间的间隔
let cellMargin : CGFloat = 5
///单个图片的高度和宽度(正方形)
let picCellWH = (UIScreen.main.bounds.width - edgeMargin * 2 - cellMargin * 2) / 3


class HomeTableViewCell: UITableViewCell {

    //MARK:- 添加连线的属性
    @IBOutlet var iconView: UIImageView!
    @IBOutlet var verifiedView: UIImageView!
    @IBOutlet var nickNameLabel: UILabel!
    @IBOutlet var vipView: UIImageView!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var sourceLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var picView: PicView!
    @IBOutlet var retweetedLabel: UILabel!
    @IBOutlet var retweetedBgView: UIView!
    
    //MARK:- 控件的约束属性
    @IBOutlet var retweetedToPicView: NSLayoutConstraint!
    @IBOutlet var contentToRetweeted: NSLayoutConstraint!
    @IBOutlet var picViewWidth: NSLayoutConstraint!
    @IBOutlet var picViewHeight: NSLayoutConstraint!
    
    
    
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
            //会员用户的昵称添加颜色
            nickNameLabel.textColor = status.vip_Image == nil ? UIColor.black : UIColor.orange
            
            //4.设置会员等级
            vipView.image = status.vip_Image
            
            //5.设置发布时间
            timeLabel.text = status.createdTimeForDisplay
            
            //6.设置发布来源
            sourceLabel.text = status.souceForDisplay
            
            //7.设置微博正文
            contentLabel.text = status.statusOpt?.text
            
            //8.计算picView的高度和宽度
            let picViewSize = calculatePicViewSize(picNum: status.picURLs.count)
            picViewWidth.constant = picViewSize.width
            picViewHeight.constant = picViewSize.height
            
            //9.设置微博的配图
            picView.picURLs = status.picURLs
            
            //10.设置转发的微博正文
            if status.statusOpt?.retweeted_status != nil {
                if let name = status.statusOpt?.retweeted_status?.userInfo?.screen_name,
                    let retweetedText = status.statusOpt?.retweeted_status?.text {
                    retweetedLabel.text = "@" + name + ":" + retweetedText
                }
                retweetedBgView.isHidden = false
                contentToRetweeted.constant = 16
            } else {
                //避免cell循环利用时出错
                retweetedLabel.text = ""
                retweetedBgView.isHidden = true
                contentToRetweeted.constant = 0
            }
            
            
        }
    }
    
    //MARK:- 系统回调的函数
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //设置单个图片的高度和宽度(正方形)
        
        
        
    }
    
  
}

//MARK:- 计算函数
extension HomeTableViewCell {
    
    ///计算picView的高度和宽度(九宫格公式: row = (count - 1) / 3 + 1)
    private func calculatePicViewSize(picNum : Int) -> CGSize {
        //图片数量为0
        if picNum == 0 {
            //修改微博正文和图片之间的距离=0
            retweetedToPicView.constant = 0
            return CGSize.zero
        }
        
        //微博有配图时,恢复微博正文和图片之间的距离
        retweetedToPicView.constant = 15
        
        //拿到collectionView的布局, 转为流水布局
        let layer = picView.collectionViewLayout as! UICollectionViewFlowLayout
        //图片数量>1时, 单个图片的size:
        layer.itemSize = CGSize.init(width: picCellWH, height: picCellWH)
        //设置图片之间的间隔最小值, 或者在storyBoard中设置
        layer.minimumLineSpacing = cellMargin
        layer.minimumInteritemSpacing = cellMargin
        
        //图片数量=1
        if picNum == 1 {
            //从本地磁盘中取出图片
            let urlString = status?.picURLs.last?.absoluteString
            let cacheImage = SDWebImageManager.shared().imageCache?.imageFromDiskCache(forKey: urlString)
                SDWebImageManager.shared().imageCache?.imageFromCache(forKey: urlString)
            //设置单张图片的size
            guard let image = cacheImage else {
                printLog("未找到缓存的图片: \(urlString!)")
                layer.itemSize = CGSize.init(width: 250, height: 250)
                return CGSize.init(width: 250, height: 250)
            }
            
            if image.size.height * 0.4 > 250 {
                layer.itemSize = CGSize.init(width: image.size.width * 0.4, height: 250)
            } else {
                layer.itemSize = CGSize.init(width: image.size.width * 0.4, height: image.size.height * 0.4)
            }
            //返回整个picView的size = 图片的size
            return layer.itemSize
        }
        
        
        //图片数量=4
        if picNum == 4 {
            let picViewWH = picCellWH * 2 + cellMargin + 1
            
            return CGSize.init(width: picViewWH, height: picViewWH)
        }
        
        //图片数量=其他
        let row = CGFloat((picNum - 1) / 3 + 1)
        let picViewW = UIScreen.main.bounds.width - edgeMargin * 2 + 1
        let picViewH = row * picCellWH + (row - 1) * cellMargin
        return CGSize.init(width: picViewW, height: picViewH)
    }
}



class PicCollectionCell: UICollectionViewCell {
    
    //MARK:- 控件的属性
    @IBOutlet var picCellView: UIImageView!
    
    //MARK:- 定义模型的属性
    var picURL : URL? {
        didSet {
            guard let picURL = picURL else {
                return
            }
            picCellView.sd_setImage(with: picURL) { (_, error : Error?,_ , url : URL?) in
                if error != nil {
                    printLog(error)
                }
            }
        }
    }
    
}

