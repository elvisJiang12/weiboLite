//
//  EmoticonCollectionViewCell.swift
//  12.自定义表情键盘
//
//  Created by Elvis on 2018/2/3.
//  Copyright © 2018年 Elvis. All rights reserved.
//

import UIKit

class EmoticonCollectionViewCell: UICollectionViewCell {
    
    private lazy var emoticonBtn = UIButton()
    
    var emoticon : Emoticon? {
        didSet {
            guard let emoticon = emoticon else {
                print("未获取到表情")
                return
            }
            
            //设置emoticonBtn的内容
            emoticonBtn.setImage(UIImage.init(contentsOfFile: emoticon.pngPath ?? ""), for: .normal)
            emoticonBtn.setTitle(emoticon.emojiCode, for: .normal)
            
            //设置删除表情
            if emoticon.isRemoveEmoticon == true {
                emoticonBtn.setImage(UIImage.init(named: "compose_emotion_delete"), for: .normal)
            }
            
            //设置空白表情
//            if emoticon.isEmptyEmoticon == true {
//                //不需要任何代码
//            }
        }
    }
    
    
    //MARK:- 重写构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK:- 设置UI界面相关
extension EmoticonCollectionViewCell {
    private func setupUI() {
        //添加子控件
        self.contentView.addSubview(emoticonBtn)
        
        //设置子控件的frame
        emoticonBtn.frame = contentView.bounds
        
        //设置子控件的属性
        emoticonBtn.isUserInteractionEnabled = false
        emoticonBtn.titleLabel?.font = UIFont.systemFont(ofSize: 30) //emoji表情的大小
    }
}
