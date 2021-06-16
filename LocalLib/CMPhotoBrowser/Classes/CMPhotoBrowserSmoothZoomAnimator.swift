//
//  CMPhotoBrowserSmoothZoomAnimator.swift
//  CMVideoPhotoDemo
//
//  Created by Allen on 2021/6/13.
//

import Foundation
import UIKit

/// 更丝滑的Zoom动画
class JXPhotoBrowserSmoothZoomAnimator: NSObject, CMPhotoBrowserAnimatedTransitioning {
    
    var showDuration: TimeInterval = 0.25
    
    var dismissDuration: TimeInterval = 0.25
    
    var isNavigationAnimation = false
    
    typealias TransitionViewAndFrame = (transitionView: UIView, thumbnailFrame: CGRect)
    typealias TransitionViewAndFrameProvider = (_ index: Int, _ destinationView: UIView) -> TransitionViewAndFrame?
    
    /// 获取转场缩放的视图与前置Frame
    var transitionViewAndFrameProvider: TransitionViewAndFrameProvider = { _, _ in return nil }
    
    /// 替补的动画方案
    lazy var substituteAnimator: CMPhotoBrowserAnimatedTransitioning = CMPhotoBrowserFadeAnimator()
    
    public init(transitionViewAndFrame: @escaping TransitionViewAndFrameProvider) {
        transitionViewAndFrameProvider = transitionViewAndFrame
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return isForShow ? showDuration : dismissDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isForShow {
            playShowAnimation(context: transitionContext)
        } else {
            playDismissAnimation(context: transitionContext)
        }
    }
    
    private func playShowAnimation(context: UIViewControllerContextTransitioning) {
        guard let browser = photoBrowser else {
            context.completeTransition(!context.transitionWasCancelled)
            return
        }
        if isNavigationAnimation,
            let fromView = context.view(forKey: .from),
            let fromViewSnapshot = snapshot(with: fromView),
            let toView = context.view(forKey: .to)  {
            toView.insertSubview(fromViewSnapshot, at: 0)
        }
        context.containerView.addSubview(browser.view)
        
        guard let (transitionView, thumbnailFrame, destinationFrame) = transitionViewAndFrames(with: browser) else {
            // 转为执行替补动画
            substituteAnimator.isForShow = isForShow
            substituteAnimator.photoBrowser = photoBrowser
            substituteAnimator.isNavigationAnimation = isNavigationAnimation
            substituteAnimator.animateTransition(using: context)
            return
        }
        browser.maskView.alpha = 0
        browser.browserView.isHidden = true
        transitionView.frame = thumbnailFrame
        context.containerView.addSubview(transitionView)
        UIView.animate(withDuration: showDuration, animations: {
            browser.maskView.alpha = 1.0
            transitionView.frame = destinationFrame
        }) { _ in
            browser.browserView.isHidden = false
            browser.view.insertSubview(browser.maskView, belowSubview: browser.browserView)
            transitionView.removeFromSuperview()
            context.completeTransition(!context.transitionWasCancelled)
        }
    }
    
    private func playDismissAnimation(context: UIViewControllerContextTransitioning) {
        guard let browser = photoBrowser else {
            return
        }
        guard let (transitionView, thumbnailFrame, destinationFrame) = transitionViewAndFrames(with: browser) else {
            // 转为执行替补动画
            substituteAnimator.isForShow = isForShow
            substituteAnimator.photoBrowser = photoBrowser
            substituteAnimator.isNavigationAnimation = isNavigationAnimation
            substituteAnimator.animateTransition(using: context)
            return
        }
        browser.browserView.isHidden = true
        transitionView.frame = destinationFrame
        context.containerView.addSubview(transitionView)
        UIView.animate(withDuration: showDuration, animations: {
            browser.maskView.alpha = 0
            transitionView.frame = thumbnailFrame
        }) { _ in
            if let toView = context.view(forKey: .to) {
                context.containerView.addSubview(toView)
            }
            transitionView.removeFromSuperview()
            context.completeTransition(!context.transitionWasCancelled)
        }
    }
    
    private func transitionViewAndFrames(with browser: CMPhotoBrowser) -> (UIView, CGRect, CGRect)? {
        
        return nil
        let browserView = browser.browserView
        let destinationView = browser.view!
//        guard let transitionContext = transitionViewAndFrameProvider(browser.pageIndex, destinationView) else {
//            return nil
//        }
//        guard let cell = browserView.visibleCells[browserView.pageIndex] as? CMPhotoBrowserZoomSupportedCell else {
//            return nil
//        }
//        let showContentView = cell.showContentView
//        let destinationFrame = showContentView.convert(showContentView.bounds, to: destinationView)
//        return (transitionContext.transitionView, transitionContext.thumbnailFrame, destinationFrame)
    }
}
