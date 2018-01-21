//
//  TitleButton.swift
//  weiboLite
//
//  Created by Elvis on 2018/1/18.
//  Copyright © 2018年 Elvis. All rights reserved.
//

import UIKit

class TitleButton: UIButton {
    
    ///重写init(frame: CGRect)函数, 自定义"首页"导航栏titleButton
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setImage(UIImage.init(named: "navigationbar_arrow_down"), for: .normal)
        setImage(UIImage.init(named: "navigationbar_arrow_up"), for: .selected)
        setTitleColor(UIColor.black, for: .normal)
        sizeToFit()
    }
    
    //swift中规定: 重写控件的init(frame)或init()方法, 必须也重写init?(coder)方法
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //重写布局子控件函数
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.titleLabel!.frame.origin.x = 0
        self.imageView!.frame.origin.x = titleLabel!.frame.size.width + 5
        
    }
    
}
