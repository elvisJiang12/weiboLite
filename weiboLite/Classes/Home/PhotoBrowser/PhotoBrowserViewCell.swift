//
//  PhotoBrowserViewCell.swift
//  weiboLite
//
//  Created by Elvis on 2018/2/10.
//  Copyright © 2018年 Elvis. All rights reserved.
//

import UIKit
import SDWebImage

class PhotoBrowserViewCell: UICollectionViewCell {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var imageView: UIImageView!
    
    
    private lazy var progressView = ProgressView()
    
    var picURL : URL? {
        didSet {
            guard let picURL = picURL else {
                printLog("未获取到图片的URL")
                return
            }
            //从缓存取出图片
            guard let image = SDWebImageManager.shared().imageCache?.imageFromDiskCache(forKey: picURL.absoluteString) else {
                printLog("未从缓存获取到图片")
                return
            }
            
            //计算imageView的frame
            let width = UIScreen.main.bounds.size.width
            let height = width / image.size.width * image.size.height
            var y : CGFloat = 0
            if height > UIScreen.main.bounds.size.height {//超长的图片
                y = 0
            } else {
                y = (UIScreen.main.bounds.size.height - height) * 0.5
            }
            imageView.frame = CGRect.init(x: 0, y: y, width: width, height: height)
            
            //设置scrollView的contentSize(滚动的size)
            scrollView.contentSize = CGSize(width: 0, height: height)
            
            //获取高清大图的URL
            guard let hdPicURL = URL.init(string: picURL.absoluteString.replacingOccurrences(of: "thumbnail", with: "bmiddle")) else {
                printLog("获取高清图的URL失败")
                return
            }
            
            //显示图片
            progressView.isHidden = false
            imageView.sd_setImage(with: hdPicURL, placeholderImage: image, options: [], progress: { (current, total, _) in
                self.progressView.progress = CGFloat(current / total)
            }) { (_, _, _, _) in
                self.progressView.isHidden = true
            }
            
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        scrollView.bounds.size.width -= 20
        
        //添加子控件
        self.addSubview(progressView)
        
        //设置子控件的frame和属性
        progressView.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
        progressView.center = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.5)
        progressView.isHidden = true
        progressView.backgroundColor = UIColor.clear
    }

}
