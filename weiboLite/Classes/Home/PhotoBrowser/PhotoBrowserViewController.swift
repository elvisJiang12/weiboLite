//
//  PhotoBrowserViewController.swift
//  weiboLite
//
//  Created by Elvis on 2018/2/9.
//  Copyright © 2018年 Elvis. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD

private let photoBrowserCell_id = "photoBrowserCell_id"

class PhotoBrowserViewController: UINavigationController {

    //MARK:- 定义的属性
    let indexPath : IndexPath
    let picURLs : [URL]
    
    //MARK:- 懒加载的空间
    private lazy var collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: PhotoBrowserCollectionViewLayout())
    private lazy var closeBtn = UIButton(bgClolor: UIColor.darkGray, fontSize:14, title: "关 闭")
    private lazy var saveBtn = UIButton(bgClolor: UIColor.darkGray, fontSize: 14, title: "保 存")
    
    
    //MARK:- 自定义控制器的构造函数
    init(indexPath : IndexPath, picURLs : [URL]) {
        self.indexPath = indexPath
        self.picURLs = picURLs
        
        //自定义控制器的构造函数时, 必须调用父类此方法
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- 系统回调的函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置UI
        setupUI()
        
        //滚动到用户点击的图片
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
    }
    
    override func loadView() {
        super.loadView()
        
        view.bounds.size.width += 20
    }

}

//MARK:- 设置UI界面
extension PhotoBrowserViewController {
    private func setupUI() {
        
        //添加子控件
        view.addSubview(collectionView)
        view.addSubview(closeBtn)
        view.addSubview(saveBtn)
        
        //设置子控件的frame
        collectionView.frame = view.bounds
        
        closeBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(view.snp.left).offset(20)
            maker.bottom.equalTo(view.snp.bottom).offset(-20)
            maker.size.equalTo(CGSize(width: 80, height: 32))
        }
        saveBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(view.snp.right).offset(-20)
            maker.bottom.equalTo(closeBtn.snp.bottom)
            maker.size.equalTo(closeBtn.snp.size)
        }
        
        //设置collectionView的属性
        //注册cell方法: 1>按类名注册, 2>按xib名注册
//        collectionView.register(PhotoBrowserViewCell.self, forCellWithReuseIdentifier: photoBrowserCell_id)
        collectionView.register(UINib.init(nibName: "PhotoBrowserViewCell", bundle: nil), forCellWithReuseIdentifier: photoBrowserCell_id)
        
        collectionView.dataSource = self
        
        //监听按钮的点击
        closeBtn.addTarget(self, action: #selector(PhotoBrowserViewController.closeBtnClick), for: .touchUpInside)
        saveBtn.addTarget(self, action: #selector(PhotoBrowserViewController.saveBtnClick), for: .touchUpInside)
    }
}

//MARK:- UICollectionView的数据源方法
extension PhotoBrowserViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //创建cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoBrowserCell_id, for: indexPath) as! PhotoBrowserViewCell
        
        
        //设置cell的数据
        cell.picURL = picURLs[indexPath.item]
        cell.delegate = self
        
        return cell
        
    }
}

//MARK:- PhotoBrowserViewCell的代理方法
extension PhotoBrowserViewController : PhotoBrowserViewCellDelegate {
    func imageViewClick() {
        closeBtnClick()
    }
    
    
}

//MARK:- 自定义CollectionViewLayout
class PhotoBrowserCollectionViewLayout : UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        //1.设置itemSize
        itemSize = collectionView!.frame.size
        scrollDirection = .horizontal
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        
        //2.设置collectionView的属性
        collectionView?.isPagingEnabled = true
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
    }
}

//MARK:- 事件监听
extension PhotoBrowserViewController {
    
    @objc private func closeBtnClick() {
        dismiss(animated: true) {
        }
    }
    
    @objc private func saveBtnClick() {
        //1.获取当天正在显示的image
        let cell = collectionView.visibleCells.first as! PhotoBrowserViewCell
        guard let image = cell.imageView.image else {
            printLog("未获取到当前显示的图片")
            return
        }
        
        //2.保存image至相册
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(PhotoBrowserViewController.image), nil)
    }
    
    //  - (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
    @objc private func image(image : UIImage, didFinishSavingWithError error : Error?, contextInfo : Any) {
        if error != nil {
            SVProgressHUD.showError(withStatus: "保存失败")
        } else {
            SVProgressHUD.showSuccess(withStatus: "保存成功")
        }
    }
}
