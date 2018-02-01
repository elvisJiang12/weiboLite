//
//  PicPickerViewCell.swift
//  weiboLite
//
//  Created by Elvis on 2018/2/1.
//  Copyright © 2018年 Elvis. All rights reserved.
//

import UIKit

class PicPickerViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    //按钮点击事件
    @IBAction func addPhotoClick() {
        NotificationCenter.default.post(name: PicPickerAddPhotoNote, object: nil)
    }
}
