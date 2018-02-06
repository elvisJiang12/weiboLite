//
//  ComposeViewController.swift
//  weiboLite
//
//  Created by Elvis on 2018/1/31.
//  Copyright © 2018年 Elvis. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {
    //MARK:-连线控件的属性
    @IBOutlet var textView: UITextView!
    @IBOutlet var placeHolderLabel: UITextField!
    @IBOutlet var picPickerBtn: UIButton!
    @IBOutlet var picPickerCollectionView: PicPickerCollectionView!
    
    
    
    //MARK:-约束的属性
    @IBOutlet var toolbarBottomCons: NSLayoutConstraint!
    @IBOutlet var picPickerCollectionViewH: NSLayoutConstraint!
    
    
    //MARK:- 懒加载的属性
    private lazy var titleView : ComposeTitleView = ComposeTitleView()
    private lazy var images : [UIImage] = [UIImage]()
    private lazy var emoticonVc : EmoticonViewController = EmoticonViewController.init {[weak self] (emoticon) in
        self?.textView.insertEmoticon(emoticon)
        self?.textViewDidChange((self?.textView)!)
    }
    
    //MARK:- 系统回调的函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置导航栏
        setupNavigationBar()
        
        //监听通知
        setupNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //弹出键盘
        textView.becomeFirstResponder()
        
        
    }
    
    //一定要移除监听
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
 
}

//设置UI界面
extension ComposeViewController {
    
    private func setupNavigationBar() {
        
        //设置NavigationBar的左右按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "取消", style: .plain, target: self, action: #selector(ComposeViewController.closeBtnClick))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "发送", style: .plain, target: self, action: #selector(ComposeViewController.composeBtnClick))
        
        //设置按钮的状态
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        //自定义NavBar中间的title
        navigationItem.titleView = titleView
        
        
    }

    private func setupNotifications() {
        //创建监听通知:键盘的弹出
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        //创建通知: 添加图片
        NotificationCenter.default.addObserver(self, selector: #selector(ComposeViewController.addPotoClick), name: PicPickerAddPhotoNote, object: nil)
        
        //创建通知: 添加图片
        NotificationCenter.default.addObserver(self, selector: #selector(ComposeViewController.reomovePotoClick), name: PicPickerRemovePhotoNote, object: nil)
    }
}

//MARK:- 事件监听
extension ComposeViewController {
    
    @objc private func closeBtnClick() {
        
        textView.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
    }
    
    @objc private func composeBtnClick() {
        print(textView.getEmoticon())
    }
    
    @objc private func keyboardWillChangeFrame(note : Notification) {
       
        //获取动画的执行时间
        let duration = note.userInfo!["UIKeyboardAnimationDurationUserInfoKey"] as! TimeInterval
        //获取键盘的y值
        let endFrame = (note.userInfo!["UIKeyboardFrameEndUserInfoKey"] as! NSValue).cgRectValue
        let y = endFrame.origin.y
        
        //计算并改变工具栏距离底部的约束
        toolbarBottomCons.constant = UIScreen.main.bounds.height - y
        
        //执行动画
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    @IBAction func picPickerImageClick() {
        //首先退出键盘
        textView.resignFirstResponder()
        
        //弹出图片选择的view
        picPickerCollectionViewH.constant = UIScreen.main.bounds.height * 0.65
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func emoticonBtnClick() {
        //首先退出系统默认键盘
        textView.resignFirstResponder()
        
        //切换自定义的键盘,  textView.inputView = nil即表示系统键盘, 并非无键盘
        textView.inputView = textView.inputView != nil ? nil : emoticonVc.view
        
        //弹出键盘
        textView.becomeFirstResponder()
    }
    
    
}

//MARK:- 添加和删除照片的事件
extension ComposeViewController {
    @objc private func addPotoClick() {
        //1.判断数据源是否可用
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            printLog("设备的照片源不可用")
            return
        }
        
        //2.创建照片选择控制器
        let ipc = UIImagePickerController.init()
        
        //3.设置照片源
        ipc.sourceType = .photoLibrary
        
        //4.设置代理
        ipc.delegate = self
        
        //5.弹出选择照片的控制器
        present(ipc, animated: true, completion: nil)
    }
    
    @objc private func reomovePotoClick(note : Notification) {
        //1.获取删除的image对象
        guard let image = note.object as? UIImage else {
            printLog("未获取到要删除的image对象")
            return
        }
        
        //2.将图片从数据中删除
        guard let index = images.index(of: image) else {
            printLog("未获取到要删除的image对象的下标值")
            return
        }
        images.remove(at: index)
        
        //3.将新的数组传给collectionView进行展示
        picPickerCollectionView.images = images
        
        //4.一旦删除图片后, 重新判断发布按钮是否可用
        navigationItem.rightBarButtonItem?.isEnabled = (images.count > 0)
        
        if images.count == 0 {
            //关闭图片选择的view
            picPickerCollectionViewH.constant = 0
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
        
    }
}

//MARK:- UIImagePickerController的代理方法
extension ComposeViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //1.获取用户选中的图片
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        //2.将选择的图片添加到数组中
        images.append(image)
        
        //3.将照片数字赋值给colletionView, 自己去展示
        picPickerCollectionView.images = images
        
        //4.关闭UIImagePickerController
        picker.dismiss(animated: true, completion: nil)
        
        //5.一旦选择图片后, 发布按钮可用
        navigationItem.rightBarButtonItem?.isEnabled = (images.count > 0)
    }
    
}

//MARK:- UITextView的代理方法
extension ComposeViewController : UITextViewDelegate {
    
    ///textView输入内容改变时调用
    func textViewDidChange(_ textView: UITextView) {
        placeHolderLabel.isHidden = textView.hasText
        navigationItem.rightBarButtonItem?.isEnabled = textView.hasText
    }
    
    ///textView滚动时调用
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //退出键盘
        textView.resignFirstResponder()
        
        
    }
    
    
}

