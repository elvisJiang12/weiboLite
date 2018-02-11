//
//  PhotoBrowserAnimator.swift
//  weiboLite
//
//  Created by Elvis on 2018/2/11.
//  Copyright © 2018年 Elvis. All rights reserved.
//

import UIKit

class PhotoBrowserAnimator: NSObject {
    
    private var isPresent : Bool = false

}

//MARK:- 转场动画的代理方法
extension PhotoBrowserAnimator : UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = false
        return self
    }
}

//MARK:- 自定义弹出和消失动画的代理方法
extension PhotoBrowserAnimator : UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.0
    }
    
    ///获取"转场的上下文": 可以通过转场的上下文获取弹出的view和消失的view
    //UITransitionContextViewKey.to : 获取弹出的view
    //UITransitionContextViewKey.from : 获取消失的view
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        isPresent ? animateForPresentedView(using: transitionContext) : animateForDismissedView(using: transitionContext)
    }
    
    ///弹出的动画
    func animateForPresentedView(using transitionContext: UIViewControllerContextTransitioning) {
        //1.取出弹出的View
        let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        
        //2.将弹出的view添加到父控件containerView中
        transitionContext.containerView.backgroundColor = UIColor.black
        transitionContext.containerView.addSubview(presentedView)
        
        //3.执行动画(渐入渐出动画)
        presentedView.alpha = 0.0
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            presentedView.alpha = 1.0
        }) { (_) in
            transitionContext.completeTransition(true)
            transitionContext.containerView.backgroundColor = UIColor.clear
        }
    }
    
    ///消失的动画
    func animateForDismissedView(using transitionContext: UIViewControllerContextTransitioning) {
        //1.取出弹出的View
        let dismissedView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        
        //2.将弹出的view添加到父控件containerView中
        transitionContext.containerView.addSubview(dismissedView)
        
        //3.执行动画(渐入渐出动画)
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            dismissedView.alpha = 0.0
        }) { (_) in
            transitionContext.completeTransition(true)
        }
    }
}
