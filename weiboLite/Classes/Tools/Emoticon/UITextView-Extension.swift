//
//  UITextView-Extension.swift
//  12.自定义表情键盘
//
//  Created by Elvis on 2018/2/6.
//  Copyright © 2018年 Elvis. All rights reserved.
//

import UIKit

//MARK:- 拓展TextView的方法
extension UITextView {
    
    ///把表情插入textView的光标所在处
    func insertEmoticon(_ emoticon : Emoticon) {
        //1.空白表情
        if emoticon.isEmptyEmoticon {
            return
        }
        
        //2.删除按钮
        if emoticon.isRemoveEmoticon {
            //删除光标位置的前一个字符
            self.deleteBackward()
            return
        }
        
        //3.emoji表情
        if emoticon.emojiCode != nil {
            //3.1获取光标所在的位置:UITextRange
            let textRange = self.selectedTextRange!
            //3.2替换emoji表情
            self.replace(textRange, withText: emoticon.emojiCode!)
            
            return
        }
        
        //4.image表情
        if emoticon.pngPath != nil {
            //4.1根据图片的路径创建"属性字符串"
            let attachment = EmoticonAttachment()
            attachment.image = UIImage.init(contentsOfFile: emoticon.pngPath!)
            attachment.chs = emoticon.chs
            //设置图片的尺寸
            let font = self.font!
            attachment.bounds = CGRect(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
            
            let attriImageString = NSAttributedString.init(attachment: attachment)
            
            //4.2创建可变的属性字符串
            let attriMString = NSMutableAttributedString(attributedString: self.attributedText)
            
            //4.3将图片属性字符串, 替换到可变属性字符串的光标所在位置
            let range = self.selectedRange
            attriMString.replaceCharacters(in: range, with: attriImageString)
            
            //显示至textView
            self.attributedText = attriMString
            
            //!!重置textView文字font
            self.font = font
            //!!光标位置调整
            self.selectedRange = NSRange.init(location: range.location + 1, length: 0)
            
            return
        }
        
    }
    
    /// 获取textView属性字符串
    /// - Returns: 返回对应的表情字符串
    func getEmoticon() -> String {
        //1.获取textView的属性字符串
        let mAttriString = NSMutableAttributedString.init(attributedString: self.attributedText)
        
        //2.遍历属性字符串
        let range = NSRange(location: 0, length: mAttriString.length)
        mAttriString.enumerateAttributes(in: range, options: []) { (dict, range, _) in
            
            if let attachment = dict[NSAttributedStringKey(rawValue: "NSAttachment")] as? EmoticonAttachment {
                mAttriString.replaceCharacters(in: range, with: attachment.chs!)
            }
        }
        
        //3.返回字符串
        return mAttriString.string
    }
}
