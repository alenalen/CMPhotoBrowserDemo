//
//  CMPhotoBrowserVideoCell.swift
//  CMVideoPhotoDemo
//
//  Created by Allen on 2021/6/11.
//

import Foundation
import UIKit
import ZFPlayer

class CMPhotoBrowserVideoCell: UICollectionViewCell {
    
    var player: ZFPlayerController?
    lazy var controlView: CMPhotoBrowserVideoControlView = {
        let view = CMPhotoBrowserVideoControlView()
        view.needShowControlView = true
        return view
    }()
        
    weak var photoBrowserView: CMPhotoBrowserView?
    /// 弱引用PhotoBrowser
    weak var photoBrowser: CMPhotoBrowser?
    
    var videoUrl: String?
    
    var imgeViewUrl: String? {
        didSet{
            if imgeViewUrl?.isEmpty == false {
                let image = ZFUtilities.image(with: UIColor(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1.0), size: self.imageView.bounds.size)
                self.imageView.setImageWithURLString(imgeViewUrl, placeholder: image)
            }
        }
    }
    
    private lazy var imageView: CMPhotoBrowserImageView = {
        let imageView = CMPhotoBrowserImageView()
        imageView.clipsToBounds = true
        imageView.tag = CMPhotoBrowserView.playViewTag
        imageView.imageDidChangedHandler = { [weak self] in
            self?.setNeedsLayout()
            self?.playUrl(nil)
        }
        return imageView
    }()
    
    var index: Int = 0
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.maximumZoomScale = 1.0
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        if #available(iOS 11.0, *) {
            view.contentInsetAdjustmentBehavior = .never
        }
        return view
    }()
    
    
    /// 播放或暂停按钮
    lazy var playOrPauseBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        btn.setImage(CMPhotoBrowserImage.getImage(named: "new_allPlay_44x44_"), for: .normal)
        btn.setImage(CMPhotoBrowserImage.getImage(named: "new_allPause_44x44_"), for: .selected)
        btn.addTarget(self, action: #selector(playPauseButtonClickAction(_:)), for: .touchUpInside)
        return btn
    }()
    
//    lazy var blurView: UIVisualEffectView = {
//        //首先创建一个模糊效果
//        let blurEffect = UIBlurEffect(style: .dark)
//        //接着创建一个承载模糊效果的视图
//        let blurView = UIVisualEffectView(effect: blurEffect)
//        //设置模糊视图的大小
//        blurView.frame.size = .zero
//        //添加模糊视图到页面view上（模糊视图下方都会有模糊效果）
//        blurView.alpha=0.2
//        return blurView
//    }()
    
    var showContentView: UIView {
        return imageView
    }
    
    /// 记录pan手势开始时imageView的位置
    private var beganFrame = CGRect.zero
    
    /// 记录pan手势开始时，手势位置
    private var beganTouch = CGPoint.zero
    
    deinit {
        self.player?.stop()
        CMPhotoBrowserLog.low("deinit - \(self.classForCoder)")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        makeConstraints()
        loadZFPlayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.contentView.addSubview(scrollView)
        scrollView.addSubview(imageView)
        //scrollView.addSubview(blurView)
        scrollView.addSubview(playOrPauseBtn)
        scrollView.delegate = self
        /// 拖动手势
        addPanGesture()
        
//        // 双击手势
//        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(onDoubleTap(_:)))
//        doubleTap.numberOfTapsRequired = 2
//        addGestureRecognizer(doubleTap)
//
//        // 单击手势
//        let singleTap = UITapGestureRecognizer(target: self, action: #selector(onSingleTap(_:)))
//        singleTap.require(toFail: doubleTap)
//        addGestureRecognizer(singleTap)
//
    }
    
    private func makeConstraints()  {
//        scrollView.snp.makeConstraints { make in
//            make.left.right.bottom.top.equalToSuperview()
//        }
//
//        imageView.snp.makeConstraints { make in
//            make.left.right.bottom.top.equalToSuperview()
//        }
        
//        self.playOrPauseBtn.snp.makeConstraints { make in
//            make.size.equalTo(CGSize(width: 60, height: 60))
//            make.center.equalTo(self.imageView.snp.center)
//        }
//        self.blurView.snp.makeConstraints { make in
//            make.left.right.bottom.top.equalTo(imageView)
//        }
    }
    
    
    private func loadZFPlayer()  {
        let playerManager = ZFAVPlayerManager()
        player = ZFPlayerController(playerManager: playerManager, containerView: imageView)
        player?.controlView = controlView
        player?.shouldAutoPlay = false
        player?.allowOrentitaionRotation = false
        //player?.disablePanMovingDirection = .all
        player?.disableGestureTypes = [.singleTap,.pan,.pinch]
        player?.playerDisapperaPercent = 1.0
    
        player?.playerPlayStateChanged = { [weak self] (manager, playState) in
            CMPhotoBrowserLog.low(playState)
            if playState == .playStatePlaying  {
                self?.playOrPauseBtn.isHidden = true
                self?.playOrPauseBtn.isSelected = true
            } else if playState == .playStatePlayStopped || playState == .playStatePaused {
                self?.playOrPauseBtn.isHidden = false
                self?.playOrPauseBtn.isSelected = false
            } 
        }
        playerManager.shouldAutoPlay = false
        
    }
    
    func playUrl(_ url: URL?) {
        if let videoUrl = self.videoUrl, let url = URL(string: videoUrl) {
            self.player?.currentPlayerManager.assetURL = url
            CMPhotoBrowserLog.low("设置播放资源：\(url)")
            self.controlView.show(title: "", coverUrl: self.imgeViewUrl ?? "")
        }
    }
    
    func stopPlayer() {
        self.player?.currentPlayerManager.pause()
        self.player?.currentPlayerManager.seek(toTime: 0, completionHandler: nil)
        playOrPauseBtn.isSelected = false
        playOrPauseBtn.isHidden = false
        controlView.show(title: "", coverUrl: self.imgeViewUrl ?? "")
        CMPhotoBrowserLog.low("滑动 停止播放")
    }
    
    /// 播放暂停
    @objc func playPauseButtonClickAction(_ sender: UIButton) {
        playOrPause()
    }
    
    private func playOrPause(){
        guard let player = self.player else {
            return
        }
        self.playOrPauseBtn.isSelected = !self.playOrPauseBtn.isSelected
        if self.playOrPauseBtn.isSelected == true {
            if player.currentPlayerManager.playState == .playStatePlayStopped {
                player.currentPlayerManager.replay()
            } else if player.currentPlayerManager.playState == .playStatePlayFailed {
                self.playUrl(nil)
            } else {
                player.currentPlayerManager.play()
            }
        } else {
            player.currentPlayerManager.pause()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.frame = CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height)
        scrollView.setZoomScale(1.0, animated: false)
        let size = computeImageLayoutSize(for: imageView.image, in: scrollView)
        let origin = computeImageLayoutOrigin(for: size, in: scrollView)
        imageView.frame = CGRect(origin: origin, size: size)
        scrollView.setZoomScale(1.0, animated: false)
        playOrPauseBtn.zf_centerX = imageView.zf_centerX
        playOrPauseBtn.zf_centerY = imageView.zf_centerY
    }
    
    // 长按事件
    typealias LongPressAction = (CMPhotoBrowserVideoCell, UILongPressGestureRecognizer) -> Void
    
    /// 长按时回调。赋值时自动添加手势，赋值为nil时移除手势
    var longPressedAction: LongPressAction? {
        didSet {
            if oldValue != nil && longPressedAction == nil {
                removeGestureRecognizer(longPress)
            } else if oldValue == nil && longPressedAction != nil {
                addGestureRecognizer(longPress)
            }
        }
    }
    
    /// 已添加的长按手势
    private lazy var longPress: UILongPressGestureRecognizer = {
        return UILongPressGestureRecognizer(target: self, action: #selector(onLongPress(_:)))
    }()
    
    private weak var existedPan: UIPanGestureRecognizer?
    
    /// 添加拖动手势
    open func addPanGesture() {
        guard existedPan == nil else {
            return
        }
        let pan = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        pan.delegate = self
        // 必须加在图片容器上，否则长图下拉不能触发
        scrollView.addGestureRecognizer(pan)
        existedPan = pan
    }
}

extension CMPhotoBrowserVideoCell {
    func computeImageLayoutSize(for image: UIImage?, in scrollView: UIScrollView) -> CGSize {
        guard let imageSize = image?.size, imageSize.width > 0 && imageSize.height > 0 else {
            return .zero
        }
        var width: CGFloat
        var height: CGFloat
        let containerSize = scrollView.bounds.size
        // 横竖屏判断
        if containerSize.width < containerSize.height {
            width = containerSize.width
            height = imageSize.height / imageSize.width * width
        } else {
            height = containerSize.height
            width = imageSize.width / imageSize.height * height
            if width > containerSize.width {
                width = containerSize.width
                height = imageSize.height / imageSize.width * width
            }
        }
        return CGSize(width: width, height: height)
    }
    
    func computeImageLayoutOrigin(for imageSize: CGSize, in scrollView: UIScrollView) -> CGPoint {
        let containerSize = scrollView.bounds.size
        var y = (containerSize.height - imageSize.height) * 0.5
        y = max(0, y)
        var x = (containerSize.width - imageSize.width) * 0.5
        x = max(0, x)
        return CGPoint(x: x, y: y)
    }
    
    func computeImageLayoutCenter(in scrollView: UIScrollView) -> CGPoint {
        var x = scrollView.contentSize.width * 0.5
        var y = scrollView.contentSize.height * 0.5
        let offsetX = (bounds.width - scrollView.contentSize.width) * 0.5
        if offsetX > 0 {
            x += offsetX
        }
        let offsetY = (bounds.height - scrollView.contentSize.height) * 0.5
        if offsetY > 0 {
            y += offsetY
        }
        return CGPoint(x: x, y: y)
    }
    
    /// 单击
    @objc open func onSingleTap(_ tap: UITapGestureRecognizer) {
        photoBrowser?.dismiss()
    }
    
    /// 双击
    @objc open func onDoubleTap(_ tap: UITapGestureRecognizer) {
        // 如果当前没有任何缩放，则放大到目标比例，否则重置到原比例
        if scrollView.zoomScale < 1.1 {
            // 以点击的位置为中心，放大
            let pointInView = tap.location(in: imageView)
            let width = scrollView.bounds.size.width / scrollView.maximumZoomScale
            let height = scrollView.bounds.size.height / scrollView.maximumZoomScale
            let x = pointInView.x - (width / 2.0)
            let y = pointInView.y - (height / 2.0)
            scrollView.zoom(to: CGRect(x: x, y: y, width: width, height: height), animated: true)
        } else {
            scrollView.setZoomScale(1.0, animated: true)
        }
    }
    

    /// 长按
    @objc open func onLongPress(_ press: UILongPressGestureRecognizer) {
        if press.state == .began {
            longPressedAction?(self, press)
        }
    }
    
    /// 响应拖动
    @objc open func onPan(_ pan: UIPanGestureRecognizer) {
        guard imageView.image != nil else {
            return
        }
        switch pan.state {
        case .began:
            beganFrame = imageView.frame
            beganTouch = pan.location(in: scrollView)
        case .changed:
            let result = panResult(pan)
            CMPhotoBrowserLog.low("panResult(pan):\(result)")
            imageView.frame = result.frame
            photoBrowser?.maskView.alpha = result.scale * result.scale
            photoBrowser?.setStatusBar(hidden: result.scale > 0.99)
        case .ended, .cancelled:
            imageView.frame = panResult(pan).frame
            CMPhotoBrowserLog.low("imageView.frame:" + "\(imageView.frame)")
            let isDown = pan.velocity(in: self).y > 0
            if isDown {
                photoBrowser?.dismiss()
            } else {
                photoBrowser?.maskView.alpha = 1.0
                photoBrowser?.setStatusBar(hidden: true)
                resetImageViewPosition()
            }
        default:
            resetImageViewPosition()
        }
    }
    
    /// 计算拖动时图片应调整的frame和scale值
    private func panResult(_ pan: UIPanGestureRecognizer) -> (frame: CGRect, scale: CGFloat) {
        // 拖动偏移量
        let translation = pan.translation(in: scrollView)
        let currentTouch = pan.location(in: scrollView)
        
        // 由下拉的偏移值决定缩放比例，越往下偏移，缩得越小。scale值区间[0.3, 1.0]
        let scale = min(1.0, max(0.3, 1 - translation.y / bounds.height))
        
        let width = beganFrame.size.width * scale
        let height = beganFrame.size.height * scale
        
        // 计算x和y。保持手指在图片上的相对位置不变。
        // 即如果手势开始时，手指在图片X轴三分之一处，那么在移动图片时，保持手指始终位于图片X轴的三分之一处
        let xRate = (beganTouch.x - beganFrame.origin.x) / beganFrame.size.width
        let currentTouchDeltaX = xRate * width
        let x = currentTouch.x - currentTouchDeltaX
        
        let yRate = (beganTouch.y - beganFrame.origin.y) / beganFrame.size.height
        let currentTouchDeltaY = yRate * height
        let y = currentTouch.y - currentTouchDeltaY
        
        return (CGRect(x: x.isNaN ? 0 : x, y: y.isNaN ? 0 : y, width: width, height: height), scale)
    }
    
    /// 复位ImageView
    private func resetImageViewPosition() {
        // 如果图片当前显示的size小于原size，则重置为原size
        let size = computeImageLayoutSize(for: imageView.image, in: scrollView)
        let needResetSize = imageView.bounds.size.width < size.width || imageView.bounds.size.height < size.height
        UIView.animate(withDuration: 0.25) {
            self.imageView.center = self.computeImageLayoutCenter(in: self.scrollView)
            if needResetSize {
                self.imageView.bounds.size = size
            }
        }
    }
}


extension CMPhotoBrowserVideoCell: UIScrollViewDelegate,UIGestureRecognizerDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        imageView.center = computeImageLayoutCenter(in: scrollView)
//        blurView.center = computeImageLayoutCenter(in: scrollView)
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // 只处理pan手势
        guard let pan = gestureRecognizer as? UIPanGestureRecognizer else {
            return true
        }
        let velocity = pan.velocity(in: self)
        // 向上滑动时，不响应手势
        if velocity.y < 0 {
            return false
        }
        // 横向滑动时，不响应pan手势
        if abs(Int(velocity.x)) > Int(velocity.y) {
            return false
        }
        // 向下滑动，如果图片顶部超出可视区域，不响应手势
        if scrollView.contentOffset.y > 0 {
            return false
        }
        // 响应允许范围内的下滑手势
        return true
    }
}
