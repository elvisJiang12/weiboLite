//
//  HomeViewController.swift
//  weiboLite
//
//  Created by Elvis on 2018/1/17.
//  Copyright © 2018年 Elvis. All rights reserved.
//

import UIKit

class HomeViewController: VisitorBaseViewController {
    
    //MARK:- 设置懒加载数据
    private lazy var titleBtn = TitleButton()
    private lazy var statuses = [Status]()
    
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
        loadStatuses()
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
    ///获取当前登录用户及其所关注用户的最新微博
    private func loadStatuses() {
        NetworkTools.shareInstance.loadStatuses { (result, error) in
            
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
            
            //3.遍历数组, 转成status模型保存
            for status in statusesArray {
                self.statuses.append(Status(dict: status))
            }
            
            //4.刷新主页的tableView数据
            
            self.tableView.reloadData()
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
        var cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell")
        if cell == nil {
            cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "HomeCell")
        }
        
        //设置cell的数据
        cell?.textLabel?.text = statuses[indexPath.row].text
        cell?.detailTextLabel?.text = statuses[indexPath.row].souceForDisplay
        
        return cell!
        
    }
    
}

