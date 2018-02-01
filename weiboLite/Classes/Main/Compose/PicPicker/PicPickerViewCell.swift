//
//  PicPickerViewCell.swift
//  weiboLite
//
//  Created by Elvis on 2018/2/1.
//  Copyright © 2018年 Elvis. All rights reserved.
//

import UIKit

class PicPickerViewCell: UICollectionViewCell {

    //MARK:- 控件的属性
    @IBOutlet var photo: UIButton!
    @IBOutlet var removeBtn: UIButton!
    @IBOutlet var imageView: UIImageView!
    
    
    //MARK:- 自定义的属性
    var imageIndex : Int = 0
    var image : UIImage? {
        didSet {
            if image != nil {
                photo.isHidden = false
                imageView.image = image
                photo.isUserInteractionEnabled = false
                removeBtn.isHidden = false
            } else {
                //最多只能添加9张图片
                if imageIndex == 9 {
                    photo.isHidden = true
                    imageView.image = nil
                    photo.isUserInteractionEnabled = false
                    removeBtn.isHidden = true
                } else {
                    photo.isHidden = false
                    imageView.image = UIImage.init(named: "compose_pic_add")
                    photo.isUserInteractionEnabled = true
                    removeBtn.isHidden = true
                }
                
            }
        }
    }
    //MARK:- 系统回调的函数
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    //按钮点击事件
    @IBAction func addPhotoClick() {
        NotificationCenter.default.post(name: PicPickerAddPhotoNote, object: nil)
    }
    
    @IBAction func removePhotoClick() {
        NotificationCenter.default.post(name: PicPickerRemovePhotoNote, object: image)
    }
    
}
