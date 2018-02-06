//
//  EmoticonViewController.swift
//  12.自定义表情键盘
//
//  Created by Elvis on 2018/2/3.
//  Copyright © 2018年 Elvis. All rights reserved.
//

import UIKit

private let emoticonCell_id = "emoticonCell_id"

class EmoticonViewController: UIViewController {

    //MARK:- 懒加载的属性
    private lazy var collectionView : UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: EmoticonCollectionFlowLayout())
    private lazy var toolBar : UIToolbar = UIToolbar()
    private lazy var manager = EmoticonManager()
    private var emoticonCallBack : (_ emoticon : Emoticon)->()
    
    //MARK:- 自定义构造函数
    init(emoticonCallBack : @escaping (_ emoticon : Emoticon)->()) {
        self.emoticonCallBack = emoticonCallBack
        //自定义控制器的构造函数时, 必须调用父类的此方法!!
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- 系统回调的函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
}

//MARK:- 设置UI相关
extension EmoticonViewController {
    
    ///设置UI界面的子控件,及约束
    private func setupUI() {
        //1.添加子控件
        self.view.addSubview(collectionView)
        self.view.addSubview(toolBar)
        
        //2.设置子控件的frame
        //2.1首先禁用AutoresizingMask自动转为约束
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.lightText
        
        //2.2设置子控件的约束(VFL语言)
        let views = ["tBar" : toolBar, "cView" : collectionView] as [String : Any]
        //水平方向的约束
        var cons = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[tBar]-0-|", options: [], metrics: nil, views: views)
        //垂直方向的约束
        cons += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[cView]-0-[tBar]-0-|", options: [.alignAllLeft, .alignAllRight], metrics: nil, views: views)
        //添加约束
        view.addConstraints(cons)
        
        //3.准备collectionView和ToolBar
        prepareForCollectionView()
        prepareForToolBar()
    }
    
    private func prepareForCollectionView() {
        //1.注册cell
        collectionView.register(EmoticonCollectionViewCell.self, forCellWithReuseIdentifier: emoticonCell_id)
        //2.设置数据源
        collectionView.dataSource = self
        
        //3.设置代理
        collectionView.delegate = self
    }
    
    private func prepareForToolBar() {
        //1.定义tollBar的标题
        let titles = ["最近", "默认", "emoji", "浪小花"]
        
        //2.设置tollBar的标题
        var tempItems = [UIBarButtonItem]()
        for i in 0..<titles.count {
            let item = UIBarButtonItem.init(title: titles[i], style: .plain, target: self, action: #selector(EmoticonViewController.barItemClick))
            item.tag = i
            tempItems.append(item)
            //调整item之间的距离, 添加flexibleSpace
            tempItems.append(UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        }
        //删除最后一个item后面的flexibleSpace
        tempItems.removeLast()
        
        toolBar.items = tempItems
        toolBar.tintColor = UIColor.orange
        
    }
}

//MARK:- UIBarButtonItem的事件监听
extension EmoticonViewController {
    @objc private func barItemClick(item : UIBarButtonItem) {
        
        //按表情分组滚动
        let indexPath = IndexPath.init(item: 0, section: item.tag)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
    }
}

//MARK:- collectionView的数据源方法
extension EmoticonViewController : UICollectionViewDataSource  {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return manager.packages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let package = manager.packages[section]
        
        return package.emoticon.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //创建cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: emoticonCell_id, for: indexPath) as! EmoticonCollectionViewCell
        
        //给cell设置数据
        let package = manager.packages[indexPath.section]
        let emoticon = package.emoticon[indexPath.item]
        cell.emoticon = emoticon
        
        return cell
    }
}


//MARK:- collectionView的代理方法
extension EmoticonViewController : UICollectionViewDelegate  {
    
    //监听cell的点击
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //获取点击的表情
        let package = manager.packages[indexPath.section]
        let emoticon = package.emoticon[indexPath.item]
        
        //把表情添加到"最近"分组中
        insertEmoticonToRecentlyGroup(emoticon: emoticon)
        
        //把点击的表情通过闭包传给外部的控制器
        emoticonCallBack(emoticon)
    }
    
    private func insertEmoticonToRecentlyGroup(emoticon : Emoticon) {
        //判断如果是点击空白表情或删除表情, 则不需要添加
        if emoticon.isEmptyEmoticon || emoticon.isRemoveEmoticon {
            return
        }
        
        //判断分组中是否有该表情
        if (manager.packages.first?.emoticon.contains(emoticon))! {//包含该表情
            let index = (manager.packages.first?.emoticon.index(of: emoticon))!
            manager.packages.first?.emoticon.remove(at: index)
        } else {//原来没有这个表情,则删除倒数第2个
            manager.packages.first?.emoticon.remove(at: Int(numverOfItemsInOnePage - 2))
        }
        
        //将表情插入到"最近"分组中第一位
        manager.packages.first?.emoticon.insert(emoticon, at: 0)
    }

}

