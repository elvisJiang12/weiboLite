//
//  PicViewCell.swift
//  weiboLite
//
//  Created by Elvis on 2018/1/28.
//  Copyright © 2018年 Elvis. All rights reserved.
//

import UIKit

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
        NotificationCenter.default.post(name: ShowPhoteBrowserNote, object: nil, userInfo: userInfo)
    }
}
