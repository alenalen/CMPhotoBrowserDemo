//
//  CMPhotoBrowser.swift.swift
//  CMVideoPhotoDemo
//
//  Created by Allen on 2021/6/11.
//

import Foundation
import UIKit

open class CMPhotoBrowser: UIViewController, UIViewControllerTransitioningDelegate {
    
    /// 自实现转场动画
    open lazy var transitionAnimator: CMPhotoBrowserAnimatedTransitioning = CMPhotoBrowserFadeAnimator()
    
    
    /// 背景蒙版
    open lazy var maskView: UIView = {
        let view = UIView()
        view.frame = .zero
        view.backgroundColor = .black
        return view
    }()
    
    private lazy var isStatusBarHidden = true
    
    /// 主视图
    lazy var browserView = CMPhotoBrowserView()
    
    deinit {
        CMPhotoBrowserLog.low("deinit - \(self.classForCoder)")
    }
    
    
    /// 滑动方向
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
 
    open override var prefersStatusBarHidden: Bool {
        return isStatusBarHidden
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .landscape
    }
    
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        return .landscapeLeft
    }
    
    open override var shouldAutorotate: Bool{
        return true
    }
    
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        CMPhotoBrowserLog.level = .forbidden
        setupUI()
        makeConstraints()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.browserView.reloadData()
    }
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.maskView.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height)
        self.browserView.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height)
    }
    
    private func setupUI(){
        self.automaticallyAdjustsScrollViewInsets = false
        maskView.frame = .zero
        self.view.addSubview(maskView)
        transitionAnimator.photoBrowser = self
        browserView.photoBrowser = self
        browserView.frame = .zero
        self.view.addSubview(browserView)
    }
    
    private func makeConstraints() {
//        self.maskView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//
//        self.browserView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
    }
    
    func setStatusBar(hidden: Bool) {
        isStatusBarHidden = hidden
        setNeedsStatusBarAppearanceUpdate()
    }

    /// 显示图片浏览器
    /// - Parameters:
    ///   - fromVC: UIViewController
    ///   - dataSource: [CMPhotoBrowserModel]
    ///   - index: 显示第几个
    public static func show(_ fromVC: UIViewController?, dataSource: [CMPhotoBrowserModel], index: Int = 0) {
        if dataSource.count == 0 {
            CMPhotoBrowserLog.low("dataSource：数据源为空")
            return
        }
        let toVC = CMPhotoBrowser()
        toVC.browserView.index = index
        toVC.browserView.dataSource = dataSource
        toVC.modalPresentationStyle = .custom
        toVC.modalPresentationCapturesStatusBarAppearance = true
        toVC.transitioningDelegate = toVC
        let from = fromVC ?? CMPhotoBrowser.topMost
        from?.present(toVC, animated: true, completion: nil)
    }

    // MARK: - 转场
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transitionAnimator.isForShow = true
        transitionAnimator.photoBrowser = self
        return transitionAnimator
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transitionAnimator.isForShow = false
        transitionAnimator.photoBrowser = self
        return transitionAnimator
    }
    
    /// 关闭PhotoBrowser
    public func dismiss() {
        setStatusBar(hidden: false)
        dismiss(animated: true, completion: nil)
    }
}


extension CMPhotoBrowser {

    /// 取最顶层的ViewController
    open class var topMost: UIViewController? {
        return topMost(of: UIApplication.shared.keyWindow?.rootViewController)
    }
    
    open class func topMost(of viewController: UIViewController?) -> UIViewController? {
        // presented view controller
        if let presentedViewController = viewController?.presentedViewController {
            return self.topMost(of: presentedViewController)
        }
        
        // UITabBarController
        if let tabBarController = viewController as? UITabBarController,
            let selectedViewController = tabBarController.selectedViewController {
            return self.topMost(of: selectedViewController)
        }
        
        // UINavigationController
        if let navigationController = viewController as? UINavigationController,
            let visibleViewController = navigationController.visibleViewController {
            return self.topMost(of: visibleViewController)
        }
        
        // UIPageController
        if let pageViewController = viewController as? UIPageViewController,
            pageViewController.viewControllers?.count == 1 {
            return self.topMost(of: pageViewController.viewControllers?.first)
        }
        
        // child view controller
        for subview in viewController?.view?.subviews ?? [] {
            if let childViewController = subview.next as? UIViewController {
                return self.topMost(of: childViewController)
            }
        }
        
        return viewController
    }
}
