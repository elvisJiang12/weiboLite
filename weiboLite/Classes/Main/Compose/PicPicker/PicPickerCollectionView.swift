//
//  PicPickerCollectionView.swift
//  weiboLite
//
//  Created by Elvis on 2018/2/1.
//  Copyright © 2018年 Elvis. All rights reserved.
//

import UIKit

private let pickPickerCell_id = "pickPickerCell"
private let edgeMargin : CGFloat = 15

class PicPickerCollectionView: UICollectionView {

    //MARK:- 自定义的属性
    var images : [UIImage] = [UIImage]() {
        didSet{
            reloadData()
            
            if images.count == 0 {
                
            }
        }
        
    }
    
    //MARK:- 系统回调的函数
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dataSource = self
        
        //注册cell
        register(UINib.init(nibName: "PicPickerViewCell", bundle: nil), forCellWithReuseIdentifier: pickPickerCell_id)
        //register(UICollectionViewCell.self, forCellWithReuseIdentifier: pickPickerCell_id)
        
        //设置collectionView的layout
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let itemWH = (UIScreen.main.bounds.width - 4 * edgeMargin) / 3
        layout.itemSize = CGSize.init(width: itemWH, height: itemWH)
        layout.minimumLineSpacing = edgeMargin
        layout.minimumInteritemSpacing = edgeMargin
        //设置内边距
        self.contentInset = UIEdgeInsets.init(top: edgeMargin, left: edgeMargin, bottom: 0, right: edgeMargin)
    }

}

//MARK:- PicPickerCollectionView的数据源方法
extension PicPickerCollectionView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //1.创建cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: pickPickerCell_id, for: indexPath) as! PicPickerViewCell
        
        //2.给cell设置数据
        cell.imageIndex = indexPath.item
        
        //存在数组越界的问题: 因为indexPath.count起始值为0, images.count起始值为1
        if indexPath.item + 1 <= images.count {
            cell.image = images[indexPath.item]
        } else {
            cell.image = nil
        }
        //或者: cell.image = indexPath.item <= images.count - 1 ? images[indexPath.item] : nil
        
        return cell
    }
    
    
}
