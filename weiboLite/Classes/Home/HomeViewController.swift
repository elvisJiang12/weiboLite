//
//  HomeViewController.swift
//  weiboLite
//
//  Created by Elvis on 2018/1/17.
//  Copyright © 2018年 Elvis. All rights reserved.
//

import UIKit
import SDWebImage
import MJRefresh


class HomeViewController: VisitorBaseViewController {
    
    //MARK:- 设置懒加载数据
    private lazy var titleBtn = TitleButton()
    private lazy var statuses = [StatusModelOpt]()
    private lazy var tipLabel = UILabel()
    
    //注意: 在闭包中如果使用当前对象的属性或调用方法, 也需要加self
    //总结: 两个地方不能省略self: 1>如果一个函数中变量名出线歧义(相同名);2>在闭包中使用当前对象的属性和方法
    private lazy var popAnimator = JWWPopoverAnimator {[weak self] (isSelected) in
        //使用闭包传递titleBtn的状态
        self?.titleBtn.isSelected = isSelected
    }
    

    //MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if !isLogin {
            //首页未登录时的访客视图, 添加旋转动画
            visitorView.addRotationAnim()
            
            return //不执行后面的代码
        }
        
        
        //设置导航栏内容
        setupNavigationBar()
        
        //请求微博数据
        //loadStatuses()
        
        //设置tableView估算高度
        self.tableView.estimatedRowHeight = 300
        //根据控件之间的约束, 自动计算tableVeiw的高度
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        //设置下拉刷新
        setupRefreshHeaderView()
        setupFooterView()
        
        //设置刷新提示的label
        setupTipLabel()
    }


}
//MARK: - 设置"首页"的UI界面
extension HomeViewController {
    
    //设置导航栏UI
    private func setupNavigationBar() {
        //设置左侧的Item
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(imageName: "navigationbar_friendattention")
        
        //设置右侧的Item
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(imageName: "navigationbar_pop")
        
        //设置中间的titleView
        titleBtn.setTitle(UserAccountTools.shareInstance.getNickName(), for: .normal)
        navigationItem.titleView = titleBtn
        
        //监听titleButton的点击
        titleBtn.addTarget(self, action: #selector(titleBtnClick), for: .touchUpInside)
    }
    
    //设置下拉刷新的headerView
    private func setupRefreshHeaderView() {
        //创建headerView
        let header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(HomeViewController.loadNewStatuses))
        //设置header属性
        header?.setTitle("下拉刷新", for: .idle)
        header?.setTitle("释放更新", for: .pulling)
        header?.setTitle("加载中...", for: .refreshing)
        
        //设置tableView的header
        tableView.mj_header = header
        
        //进入刷新状态
        tableView.mj_header.beginRefreshing()
    }
    
    //设置上拉加载View
    private func setupFooterView() {
        let footer = MJRefreshAutoFooter.init(refreshingTarget: self, refreshingAction: #selector(HomeViewController.loadMoreStatuses))
        
        
        tableView.mj_footer = footer
//        tableView.mj_footer.beginRefreshing()
    }
    
    //设置下拉刷新的tipLabel
    private func setupTipLabel() {
        //1.将TipLabel添加到父控件中
        navigationController?.navigationBar.insertSubview(tipLabel, at: 0)
        
        //设置tipLabel的frame
        tipLabel.frame = CGRect(x: 0, y: 10, width: UIScreen.main.bounds.width, height: 32)
        
        //设置tipLabel的属性
        tipLabel.isHidden = true
        tipLabel.backgroundColor = UIColor.orange
        tipLabel.textColor = UIColor.white
        tipLabel.font = UIFont.systemFont(ofSize: 14)
        tipLabel.textAlignment = .center
        
    }
    
    //显示tipLabel
    private func showTipLabel(count: Int) {
        
        tipLabel.isHidden = false
        tipLabel.text = count == 0 ? "没有新数据" : "更新了\(count)条微博"
        
        //执行动画
        UIView.animate(withDuration: 1, animations: {
            self.tipLabel.frame.origin.y = 44
        }) { (_) in
            UIView.animate(withDuration: 1, delay: 2, options: [], animations: {
                self.tipLabel.frame.origin.y = 10
            }, completion: { (_) in
                self.tipLabel.isHidden = true
            })
        }
    }
}

//MARK: - 监听事件
extension HomeViewController {
    
    ///监听titleButton的点击
    @objc private func titleBtnClick(titleBtn: TitleButton) {
        
        //设置按钮状态,不能使用此方法, 应该用闭包传递
        //titleBtn.isSelected = isSelected
        
        //1.创建弹出的控制器
        let popoverVc = PopoverViewController()
        //2.设置控制器的弹出样式, modalPresentationStyle.custom表示弹出后,以前的view不删除
        popoverVc.modalPresentationStyle = .custom
        //3.设置转场动画的代理
        popoverVc.transitioningDelegate = self.popAnimator
        
        //弹出控制器
        present(popoverVc, animated: true, completion: nil)
        
    }
   
}

//MARK: - 请求网络数据
extension HomeViewController {
    
    ///获取当前用户最新的微博数据
    @objc private func loadNewStatuses() {
        loadStatuses(isUpdate: true)
    }
    
    ///上拉获取当前用户更多的微博数据
    @objc private func loadMoreStatuses() {
        loadStatuses(isUpdate: false)
    }
    
    
    ///获取当前登录用户及其所关注用户的最新微博
    private func loadStatuses(isUpdate : Bool) {
        var sinceId : Int64 = 0
        var maxID : Int64 = 0
        //下拉刷新时, isUpdate = true
        if isUpdate {
            sinceId = (statuses.first?.statusOpt?.mid) ?? 0
        } else {//上拉加载更多时, isUpdate = false
            maxID = statuses.last?.statusOpt?.mid ?? 0
            maxID = maxID == 0 ? 0 : (maxID - 1)
        }
        
        NetworkTools.shareInstance.loadStatuses(since_id: sinceId, max_id: maxID) { (result, error) in
            
            //1.错误校验
            if error != nil {
                printLog(error)
                return
            }
            
            //2.获取数据(微博的数组)
            guard let statusesArray = result else {
                printLog("未获取到登录用户所关注用户的微博数据")
                return
            }
            
            //3.遍历数组, 转成模型保存
            var newStatuses : [StatusModelOpt] = [StatusModelOpt]()
            for status in statusesArray {
                //先保存为Status模型
                let tempStatus = Status.init(dict: status)
                //再转为StatusModelOpt模型保存
                newStatuses.append(StatusModelOpt(statusOpt: tempStatus))
            }
            
            if isUpdate {
                //新刷新的微博数据, 插入到原模型数据的前面
                self.statuses = newStatuses + self.statuses
            } else {
                //底部上拉加载的微博数据, 插入到原模型数据的最后
                self.statuses = self.statuses + newStatuses
            }
            
            
            //4.缓存微博的图片(异步保存)
            self.cacheImages(statuses: newStatuses) //只需要缓存新刷新的数据即可
            
            
            //5.刷新主页的tableView数据
            
            
        }
    }
    
    //异步操作下载微博的图片, 然后才
    private func cacheImages(statuses : [StatusModelOpt]) {
        
        //0.创建异步操作的group
        let group = DispatchGroup.init()
        
        //1.缓存图片
        for status in statuses {
            for picURL in status.picURLs {
                group.enter()  //进入group
                SDWebImageManager.shared().imageDownloader?.downloadImage(with: picURL, options: [], progress: nil, completed: { (_, _, _, _) in
                    group.leave()   //离开group
                })
            }
            
        
        }
        
        //2.刷新tableView数据
        group.notify(queue: DispatchQueue.main) {
            printLog("加载tableView数据")
            self.tableView.reloadData()
            
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            
            //显示提示的label
            self.showTipLabel(count: statuses.count)
        }
        
    }
    
}

//MARK: - TableView的代理方法
extension HomeViewController {
    
    //设置tableView的行数
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statuses.count
    }
    
    //设置tableView每个cell的数据
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //创建cell, 并附带标识循环利用
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell") as! HomeTableViewCell
//        if cell == nil {
//            cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "HomeCell") as! HomeTableViewCell
//        }
        
        //设置cell的数据
        cell.status = statuses[indexPath.row]
        
        return cell
        
    }
    
}

