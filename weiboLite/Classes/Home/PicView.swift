//
//  PicViewCell.swift
//  weiboLite
//
//  Created by Elvis on 2018/1/28.
//  Copyright © 2018年 Elvis. All rights reserved.
//

import UIKit
import SDWebImage

class PicView: UICollectionView {

    //MARK:- 定义属性
    var picURLs : [URL] = [URL]() {
        didSet {
            self.reloadData()
        }
    }
    
    //MARK:- 系统回调的函数
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //设置数据源和代理
        dataSource = self
        delegate = self
    }

}

//MARK:- UICollectionView的数据源方法
extension PicView : UICollectionViewDataSource {
    
    //设置cell的数量
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picURLs.count
    }
    
    //设置cell的内容
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PicViewCell", for: indexPath) as! PicCollectionCell
        //设置数据
        cell.picURL = picURLs[indexPath.row]
        
        return cell
    }
    
    
}

//MARK:- UICollectionView的代理方法
extension PicView : UICollectionViewDelegate {
    
    ///监听cell的点击
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //获取需要传递的参数
        let userInfo = [ShowPhoteBrowserIndexPathKey : indexPath,
                        ShowPhoteBrowserURLsKey : picURLs] as [String : Any]
        
        //发出通知, 传递给viewController
        NotificationCenter.default.post(name: ShowPhoteBrowserNote, object: self, userInfo: userInfo)
    }
}


//MARK:- UICollectionView的代理方法
extension PicView : AnimationPresentedDelegate {
    func startRect(indexPath: IndexPath) -> CGRect {
        //获取cell
        let cell = self.cellForItem(at: indexPath)!
        
        //获取cell相对于整个screen的frame
        return self.convert(cell.frame, to: UIApplication.shared.keyWindow!)
    }
    
    func endRect(indexPath: IndexPath) -> CGRect {
        //1.获取image对象
        let picURL = picURLs[indexPath.item]
        let image = SDWebImageManager.shared().imageCache?.imageFromDiskCache(forKey: picURL.absoluteString)
        
        //2.计算动画结束后的frame
        let w = UIScreen.main.bounds.width
        let h = w / (image?.size.width)! * (image?.size.height)!
        var y : CGFloat = 0
        if h > UIScreen.main.bounds.height {//超长的图
            y = 0
        } else {
            y = (UIScreen.main.bounds.height - h) * 0.5
        }
        
        return CGRect(x: 0, y: y, width: w, height: h)
    }
    
    func imageView(indexPath: IndexPath) -> UIImageView {
        let imageView = UIImageView()
        
        //设置imageView的属性
        let picURL = picURLs[indexPath.item]
        let image = SDWebImageManager.shared().imageCache?.imageFromDiskCache(forKey: picURL.absoluteString)
        imageView.image = image
        //imageView.contentMode = .scaleAspectFit
        
        return imageView
    }
    

}
