//
//  JWWPopoverAnimator.swift
//  weiboLite
//
//  Created by Elvis on 2018/1/21.
//  Copyright © 2018年 Elvis. All rights reserved.
//

import UIKit

class JWWPopoverAnimator: NSObject {
    
    //设置懒加载数据
    private lazy var isPresented : Bool = false

}



//MARK: - 转场动画的代理方法
extension JWWPopoverAnimator : UIViewControllerTransitioningDelegate {
    
    //自定义弹出view的尺寸
    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController)
        -> UIPresentationController? {
            
            return JWWPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    ///自定义弹出的动画
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        return self
    }
    
    ///自定义消失的动画
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        return self
    }
    
    
}

//MARK:- 弹出和消失动画的代理方法
extension JWWPopoverAnimator : UIViewControllerAnimatedTransitioning {
    
    ///动画执行的时间
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.7
    }
    
    ///获取"转场的上下文": 可以通过转场的上下文获取弹出的view和消失的view
    //UITransitionContextViewKey.to : 获取弹出的view
    //UITransitionContextViewKey.from : 获取消失的view
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        isPresented ? animationForPresentedView(transitionContext: transitionContext) : animationForDismissedView(transitionContext: transitionContext)
    }
    
    ///自定义弹出动画
    func animationForPresentedView(transitionContext: UIViewControllerContextTransitioning) {
        //1.获取弹出的view
        let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        
        //2.将弹出的view添加到containerView中
        transitionContext.containerView.addSubview(presentedView)
        
        //3.执行动画
        presentedView.transform = CGAffineTransform(scaleX: 1.0, y: 0.0) //开始改变的比例: x不变,y=0
        presentedView.layer.anchorPoint = CGPoint(x: 0.5, y: 0) //动画的锚点: view的X中心位置, y=0
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            //结束动画时的比例, 弹出view恢复原形
            presentedView.transform = CGAffineTransform.identity
        }) { (_) in //bool类型的变量, 如果不需要使用,可以用"_"代替
            //必须通知转场上下文: 动画完成
            transitionContext.completeTransition(true)
        }
    }
    
    ///自定义消失动画
    func animationForDismissedView(transitionContext: UIViewControllerContextTransitioning) {
        //1.获取弹出的view
        let dismissedView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        
        //2.执行动画
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            //结束动画时的比例, 弹出view恢复原形
            dismissedView.transform = CGAffineTransform(scaleX: 1.0, y: 0.00001) //y=0则立即消失,处理办法写个很小的值
        }) { (_) in //bool类型的变量, 如果不需要使用,可以用"_"代替
            //从父类中移除弹出的view
            dismissedView.removeFromSuperview()
            //必须通知转场上下文: 动画完成
            transitionContext.completeTransition(true)
        }
    }
    
    
}
