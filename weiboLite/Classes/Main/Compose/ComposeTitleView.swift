//
//  ComposeTitleView.swift
//  weiboLite
//
//  Created by Elvis on 2018/1/31.
//  Copyright © 2018年 Elvis. All rights reserved.
//

import UIKit
import SnapKit

class ComposeTitleView: UIView {
    //MARK:- 懒加载属性
    private lazy var titleLabel : UILabel = UILabel()
    private lazy var nicknameLabel : UILabel = UILabel()

    //MARK:-  构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupTitle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


//MARK:- 设置UI
extension ComposeTitleView {
    private func setupTitle() {
        addSubview(titleLabel)
        addSubview(nicknameLabel)
        
        //设置子控件的frame
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self.snp.top).offset(-15)
        }
        nicknameLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(titleLabel.snp.centerX)
            make.top.equalTo(titleLabel.snp.bottom).offset(3)
        }
        
        //设置控件的属性
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        nicknameLabel.font = UIFont.systemFont(ofSize: 13)
        nicknameLabel.textColor = UIColor.lightGray
        
        //设置标题的内容
        titleLabel.text = "发微博"
        nicknameLabel.text = UserAccountTools.shareInstance.userInfo?.screen_name
    }
}
