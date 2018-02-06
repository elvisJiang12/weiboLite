//
//  EmoticonCollectionFlowLayout.swift
//  12.自定义表情键盘
//
//  Created by Elvis on 2018/2/3.
//  Copyright © 2018年 Elvis. All rights reserved.
//

import UIKit

class EmoticonCollectionFlowLayout: UICollectionViewFlowLayout {

    //MARK:- 自定义布局
    override func prepare() {
        super.prepare()
        
        //计算item的高度和宽度(正方形), 一行放7个
        let itemWH = UIScreen.main.bounds.width / numberOfItemsInOneRow
        itemSize = CGSize.init(width: itemWH, height: itemWH)
        
        //设置layout的属性
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        //滚动的方向
        scrollDirection = UICollectionViewScrollDirection.horizontal
        
        //设置collectionView的布局
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.isPagingEnabled = true
        
        
        //设置内边距
        let edgeMargin = (collectionView!.bounds.height - itemWH * numberOfLinsInOnePage) * 0.5
        collectionView?.contentInset = UIEdgeInsetsMake(edgeMargin, 0, edgeMargin, 0)
    }
}
