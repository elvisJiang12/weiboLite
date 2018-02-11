//
//  PhotoBrowserAnimator.swift
//  weiboLite
//
//  Created by Elvis on 2018/2/11.
//  Copyright © 2018年 Elvis. All rights reserved.
//

import UIKit

//MARK:- 自定义协议及方法(面向协议开发)
protocol AnimationPresentedDelegate : NSObjectProtocol {
    ///获取开始的frame
    func startRect(indexPath : IndexPath) -> CGRect
    ///获取结束的frame
    func endRect(indexPath : IndexPath) -> CGRect
    ///获取动画的imageView
    func imageView(indexPath : IndexPath) -> UIImageView
}

protocol AnimationDismissDelegate : NSObjectProtocol {
    ///获取消失图片的index
    func indexPathForDismiss() -> IndexPath
    ///获取动画的imageView
    func imageViewForDismiss() -> UIImageView
}

class PhotoBrowserAnimator: NSObject {
    
    private var isPresent : Bool = false

    //代理的属性
    var presentedDelegate : AnimationPresentedDelegate?
    var dismissDelegate : AnimationDismissDelegate?
    
    var indexPath : IndexPath?
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
        return 0.5
    }
    
    ///获取"转场的上下文": 可以通过转场的上下文获取弹出的view和消失的view
    //UITransitionContextViewKey.to : 获取弹出的view
    //UITransitionContextViewKey.from : 获取消失的view
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        isPresent ? animateForPresentedView(using: transitionContext) : animateForDismissedView(using: transitionContext)
    }
    
    ///弹出的动画
    func animateForPresentedView(using transitionContext: UIViewControllerContextTransitioning) {
        //0.nil值校验
        guard let presentedDelegate = presentedDelegate, let indexPath = indexPath else {
            return
        }
        
        //1.取出弹出的View
        let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        
        //2.将弹出的view添加到父控件containerView中
        transitionContext.containerView.backgroundColor = UIColor.black
        transitionContext.containerView.addSubview(presentedView)
        
        //3.获取执行动画的imageView
        let imageView = presentedDelegate.imageView(indexPath: indexPath)
        let startRect = presentedDelegate.startRect(indexPath: indexPath)
        let endRect = presentedDelegate.endRect(indexPath: indexPath)
        //动画开始的frame
        transitionContext.containerView.addSubview(imageView)
        imageView.frame = startRect
        
        //3.执行动画(渐入渐出动画)
        presentedView.alpha = 0.0
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            //动画结束的frame
            imageView.frame = endRect
        }) { (_) in
            imageView.removeFromSuperview()
            presentedView.alpha = 1.0
            transitionContext.containerView.backgroundColor = UIColor.clear
            transitionContext.completeTransition(true)
        }
    }
    
    ///消失的动画
    func animateForDismissedView(using transitionContext: UIViewControllerContextTransitioning) {
        //0.nil值校验
        guard let dismissDelegate = dismissDelegate, let presentedDelegate = presentedDelegate else {
            return
        }
        
        //1.取出消失的View
        let dismissedView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        dismissedView.removeFromSuperview()
        
        let imageView = dismissDelegate.imageViewForDismiss()
        let indexPath = dismissDelegate.indexPathForDismiss()
        
        //2.将消失的view添加到父控件containerView中
        transitionContext.containerView.addSubview(imageView)
        
        //3.执行动画
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            //动画结束的frame
            imageView.frame = presentedDelegate.startRect(indexPath: indexPath)
            
        }) { (_) in
            transitionContext.completeTransition(true)
        }
    }
}
