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
        
        //设置数据源
        dataSource = self
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
