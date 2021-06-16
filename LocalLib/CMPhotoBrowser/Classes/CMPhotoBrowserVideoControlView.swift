//
//  CMPhotoBrowserVideoControlView.swift
//  CMVideoPhotoDemo
//
//  Created by Allen on 2021/6/13.
//

import Foundation
import UIKit
import ZFPlayer

class CMPhotoBrowserVideoControlView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        autoFadeTimeInterval = 0.2
        autoHiddenTimeInterval = 2.5
        resetControlView()
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 添加子控件
    private func setupUI(){
        //self.addSubview(self.topToolView)
        //self.addSubview(self.playOrPauseBtn)
        self.addSubview(self.bottomToolView)
        //self.addSubview(self.bottomPgrogress)
        self.addSubview(self.activity)
    }
    
    //MARK: - 添加子控件约束
    override func layoutSubviews() {
        super.layoutSubviews()
        var min_x:CGFloat = 0.0
        var min_y:CGFloat = 0.0
        var min_w:CGFloat = 0.0
        var min_h:CGFloat = 0.0
        let min_view_w:CGFloat = self.bounds.size.width
        let min_view_h:CGFloat = self.bounds.size.height
        let min_margin:CGFloat = 20.0
        
        self.coverImageView.frame = self.bounds
        
        min_w = 80.0
        min_h = 80.0
        self.activity.frame = CGRect(x: min_x, y: min_y, width: min_w, height: min_h)
        self.activity.zf_centerX = self.zf_centerX
        self.activity.zf_centerY = self.zf_centerY + 10
        

        min_x = 0
        min_y = 0
        min_w = min_view_w
        min_h = 40.0
        self.topToolView.frame = CGRect(x: min_x, y: min_y, width: min_w, height: min_h)
        
        
        min_x = 15
        min_y = 0;
        min_w = min_view_w - min_x - 15;
        min_h = 30;
        self.titleLabel.frame = CGRect(x: min_x, y: min_y, width: min_w, height: min_h)
        self.titleLabel.zf_centerY = self.topToolView.zf_centerY;
        
        min_h = 80
        min_x = 0
        min_y = min_view_h - min_h
        min_w = min_view_w
        self.bottomToolView.frame = CGRect(x: min_x, y: min_y, width: min_w, height: min_h)
        
        
        min_x = min_margin
        min_y = 16
        min_w = 44
        min_h = 44;
        self.playOrPauseBtn.frame =  CGRect(x: min_x, y: min_y, width: min_w, height: min_h)
        
        
        min_x = self.playOrPauseBtn.zf_right + 10
        min_w = 62
        min_h = 28
        min_y = (self.playOrPauseBtn.zf_height - min_h)/2
        self.currentTimeLabel.frame =  CGRect(x: min_x, y: min_y, width: min_w, height: min_h)
        self.currentTimeLabel.zf_centerY = self.playOrPauseBtn.zf_centerY
        
        
//        min_w = 28
//        min_h = min_w
//        min_x = self.bottomToolView.zf_width - min_w - min_margin
//        min_y = 0
//        self.fullScreenBtn.frame =  CGRect(x: min_x, y: min_y, width: min_w, height: min_h)
//        self.fullScreenBtn.zf_centerY = self.currentTimeLabel.zf_centerY
        
        min_w = 62
        min_h = 28
        min_x = self.bottomToolView.zf_right - min_w - 10
        min_y = (self.playOrPauseBtn.zf_height - min_h)/2
        self.totalTimeLabel.frame =  CGRect(x: min_x, y: min_y, width: min_w, height: min_h)
        self.totalTimeLabel.zf_centerY = self.currentTimeLabel.zf_centerY
        
        min_x = self.currentTimeLabel.zf_right + 4
        min_y = 0
        min_w = self.totalTimeLabel.zf_left - min_x - 4
        min_h = 30
        self.slider.frame =  CGRect(x: min_x, y: min_y, width: min_w, height: min_h)
        self.slider.zf_centerY = self.currentTimeLabel.zf_centerY
        
//        min_x = 0
//        min_y = min_view_h - 1
//        min_w = min_view_w
//        min_h = 1
//        self.bottomPgrogress.frame = CGRect(x: min_x, y: min_y, width: min_w, height: min_h)
    
        if (!self.isShow) {
            self.topToolView.zf_y = -self.topToolView.zf_height
            self.bottomToolView.zf_y = self.zf_height
            self.playOrPauseBtn.alpha = 0
        } else {
            self.topToolView.zf_y = 0
            self.bottomToolView.zf_y = self.zf_height - self.bottomToolView.zf_height
            self.playOrPauseBtn.alpha = 1
        }
    }
    

    public func show(title: String?, coverUrl: String)  {
        let placeholder = ZFUtilities.image(with: UIColor(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1.0), size: self.coverImageView.bounds.size)
        self.resetControlView()
        self.layoutIfNeeded()
        self.setNeedsLayout()
        self.titleLabel.text = title
        self.player?.orientationObserver.fullScreenMode = .automatic
        self.player?.currentPlayerManager.view.coverImageView.setImageWithURLString(coverUrl, placeholder: placeholder)
        if needShowControlView {
            showControlView(animated: false)
        }
    }
    
    /// 记录播放器
    var zfPlayer: ZFPlayerController?
    /// 控制层自动隐藏的时间，默认2.5秒
    var autoHiddenTimeInterval: TimeInterval = 2.5
    /// 控制层显示、隐藏动画的时长，默认0.25秒
    var autoFadeTimeInterval: TimeInterval = 0.25

    /// 底部工具栏
    lazy var topToolView: UIView = {
        let view = UIView()
        let image = CMPhotoBrowserImage.getImage(named:"ZFPlayer_top_shadow")
        view.layer.contents = image?.cgImage
        view.addSubview(backBtn)
        view.addSubview(titleLabel)
        return view
    }()
    
    /// 播放或暂停按钮
    lazy var backBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(CMPhotoBrowserImage.getImage(named: "ZFPlayer_back_full"), for: .normal)
        return btn
    }()
    
    /// 标题
    lazy var titleLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = .white
        lab.font = UIFont.systemFont(ofSize: 14)
        lab.textAlignment = .left
        return lab
    }()
    
    /// 播放或暂停按钮
    lazy var playOrPauseBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(CMPhotoBrowserImage.getImage(named: "new_allPlay_44x44_"), for: .normal)
        btn.setImage(CMPhotoBrowserImage.getImage(named: "new_allPause_44x44_"), for: .selected)
        btn.addTarget(self, action: #selector(playPauseButtonClickAction(_:)), for: .touchUpInside)
        return btn
    }()
    
    
    /// 底部工具栏
    lazy var bottomToolView: UIView = {
        let view = UIView()
        let image = CMPhotoBrowserImage.getImage(named:"ZFPlayer_bottom_shadow")
        view.layer.contents = image?.cgImage
        view.addSubview(slider)
        view.addSubview(playOrPauseBtn)
        view.addSubview(currentTimeLabel)
        view.addSubview(totalTimeLabel)
        //view.addSubview(fullScreenBtn)
        return view
    }()
    
    /// 播放的当前时间
    lazy var currentTimeLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = .white
        lab.font = UIFont.systemFont(ofSize: 14)
        lab.textAlignment = .center
        return lab
    }()
    
    /// 播放的当前时间
    lazy var slider: ZFSliderView = {
        let sl = ZFSliderView()
        sl.delegate = self;
        sl.maximumTrackTintColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.5)
        sl.bufferTrackTintColor  = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.3)
        sl.minimumTrackTintColor = UIColor(red: 255/255.0, green: 210/255.0, blue: 54/255.0, alpha: 1.0)
        sl.setThumbImage(CMPhotoBrowserImage.getImage(named: "ZFPlayer_slider"), for: .normal)
        sl.sliderHeight = 2.0
        sl.sliderRadius = 1.0
        return sl
    }()
    
    /// 视频总时间
    lazy var totalTimeLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = .white
        lab.font = UIFont.systemFont(ofSize: 14)
        lab.textAlignment = .center
        return lab
    }()
    
    /// 全屏按钮
    lazy var fullScreenBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(CMPhotoBrowserImage.getImage(named: "ZFPlayer_fullscreen"), for: .normal)
        btn.addTarget(self, action: #selector(fullScreenButtonClickAction(_:)), for: .touchUpInside)
        return btn
    }()
    
    var isShow: Bool = false
    
    var needShowControlView: Bool = false
    
    var controlViewAppeared: Bool = false
    
    var afterBlock: DispatchWorkItem?

    var sumTime: TimeInterval = 0.0
    
    /// 底部播放进度
    lazy var bottomPgrogress: ZFSliderView = {
        let sl = ZFSliderView()
        sl.delegate = self;
        sl.maximumTrackTintColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.5)
        sl.bufferTrackTintColor  = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.3)
        sl.minimumTrackTintColor = UIColor(red: 255/255.0, green: 210/255.0, blue: 54/255.0, alpha: 1.0)
        sl.setThumbImage(CMPhotoBrowserImage.getImage(named: "ZFPlayer_slider"), for: .normal)
        sl.sliderHeight = 2.0
        sl.sliderRadius = 1.0
        return sl
    }()
    
    /// 加载loading
    lazy var activity: ZFSpeedLoadingView = {
        let activity = ZFSpeedLoadingView()
        return activity
    }()
    
    /// 封面图
    lazy var coverImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.isUserInteractionEnabled = true
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
}


 
extension CMPhotoBrowserVideoControlView{
    //MARK: - ACTION
    @objc private func playPauseButtonClickAction(_ sender: UIButton) {
        playOrPause()
    }
    
    @objc private func fullScreenButtonClickAction(_ sender: UIButton) {
        guard let player = self.player else {
            return
        }
        self.player?.enterFullScreen(!player.isFullScreen, animated: true)
    }
    
    private func playOrPause(){
        guard let player = self.player else {
            return
        }
        self.playOrPauseBtn.isSelected = !self.playOrPauseBtn.isSelected
        if self.playOrPauseBtn.isSelected == true {
            if player.currentPlayerManager.playState == .playStatePlayStopped {
                player.currentPlayerManager.replay()
            } else {
                player.currentPlayerManager.play()
            }
        } else {
            player.currentPlayerManager.pause()
        }
    }
    
    private func playBtnSelectedState(selected: Bool) {
        self.playOrPauseBtn.isSelected = selected
    }
    
    /// 重置ControlView
    private func resetControlView()  {
        self.bottomToolView.alpha = 1.0
        self.slider.value = 0
        self.slider.bufferValue = 0
        self.currentTimeLabel.text = "00:00"
        self.totalTimeLabel.text = "00:00"
        self.backgroundColor  = UIColor.clear
        //self.playOrPauseBtn.isSelected = true
        self.titleLabel.text = ""
    }
    
    func showControlView()  {
        self.topToolView.alpha           = 1
        self.bottomToolView.alpha        = 1
        self.isShow                      = true
        self.topToolView.zf_y            = 0
        self.bottomToolView.zf_y         = self.zf_height - self.bottomToolView.zf_height
        self.playOrPauseBtn.alpha        = 1
        //self.player.statusBarHidden      = false
    }
    
    
    func hideControlView()  {
        self.isShow                      = false
        self.topToolView.zf_y            = -self.topToolView.zf_height
        self.bottomToolView.zf_y         = self.zf_height
        self.playOrPauseBtn.alpha        = 0
        self.topToolView.alpha           = 0
        self.bottomToolView.alpha        = 0
        //self.player.statusBarHidden      = false
    }
    
    func autoFadeOutControlView()  {
        if needShowControlView == true {
            return
        }
        
        self.controlViewAppeared = true
        self.cancelAutoFadeOutControlView()
        
        
        self.afterBlock = DispatchWorkItem { [weak self] in
            self?.hideControlView(animated: true)
        }
        
        guard let afterBlock = self.afterBlock else {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + self.autoHiddenTimeInterval, execute: afterBlock)
    }
    
    /// 取消延时隐藏controlView的方法
    func cancelAutoFadeOutControlView()  {
        if (self.afterBlock != nil) {
            self.afterBlock?.cancel()
            self.afterBlock = nil;
        }
    }
    
    /// 隐藏控制层
    func hideControlView(animated: Bool) {
        if needShowControlView == true {
            return
        }
        
        self.controlViewAppeared = false
        UIView.animate(withDuration: animated ? self.autoFadeTimeInterval : 0) {
            self.hideControlView()
        } completion: { result in
            self.bottomPgrogress.isHidden = false
        }
    }
    
    /// 显示控制层
    func showControlView(animated: Bool) {
        self.controlViewAppeared = true
        autoFadeOutControlView()
        UIView.animate(withDuration: animated ? self.autoFadeTimeInterval : 0) {
            self.showControlView()
        } completion: { result in
            self.bottomPgrogress.isHidden = true
        }
    }
    
    /// 调节播放进度slider和当前时间更新
    func sliderValueChanged(value: Float, currentTimeString: String) {
        self.slider.value = value
        self.currentTimeLabel.text = currentTimeString
        self.slider.isdragging = true
        UIView.animate(withDuration: 0.3) {
            self.slider.sliderBtn.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }
    }
    
    func sliderChangeEnded()  {
        self.slider.isdragging = false
        UIView.animate(withDuration: 0.3) {
            self.slider.sliderBtn.transform = .identity
        }
    }
    
    func shouldResponseGesture(point: CGPoint, gestureType: ZFPlayerGestureType, touch: UITouch) -> Bool {
        let sliderRect = self.bottomToolView.convert(self.slider.frame, to: self)
        if (sliderRect.contains(point)) {
            return false
        }
        return true
    }
}

 
extension CMPhotoBrowserVideoControlView: ZFPlayerMediaControl{
    var player: ZFPlayerController? {
        get {
            return zfPlayer
        }
        set(player) {
            self.zfPlayer = player
        }
    }
    
    //MARK: - ZFPlayerControlViewDelegate
    /// 手势筛选，返回NO不响应该手势
    func gestureTriggerCondition(_ gestureControl: ZFPlayerGestureControl, gestureType: ZFPlayerGestureType, gestureRecognizer: UIGestureRecognizer, touch: UITouch) -> Bool {
        guard let player = self.player else {
            return false
        }
        
        let point = touch.location(in: self)
        
        if (player.isSmallFloatViewShow && !player.isFullScreen && gestureType != .singleTap) {
            return false;
        }
        return shouldResponseGesture(point: point, gestureType: gestureType, touch: touch)
    }
    
    /// 单击手势事件
    func gestureSingleTapped(_ gestureControl: ZFPlayerGestureControl) {
        guard let player = self.player else {
            return
        }
        if player.isSmallFloatViewShow && !player.isFullScreen {
            player.enterFullScreen(true, animated: true)
        } else {
            if controlViewAppeared {
                hideControlView(animated: true)
            } else {
                /// 显示之前先把控制层复位，先隐藏后显示
                hideControlView(animated: false)
                showControlView(animated: true)
            }
        }
    }
    
    /// 双击手势事件
    func gestureDoubleTapped(_ gestureControl: ZFPlayerGestureControl) {
        self.playOrPause()
    }
    
    /// 捏合手势事件，这里改变了视频的填充模式
    func gesturePinched(_ gestureControl: ZFPlayerGestureControl, scale: Float) {
        if scale > 1 {
            self.player?.currentPlayerManager.scalingMode = .fill
        } else {
            self.player?.currentPlayerManager.scalingMode = .aspectFit
        }
    }
    
   
    /// 准备播放
    func videoPlayer(_ videoPlayer: ZFPlayerController, prepareToPlay assetURL: URL) {
        CMPhotoBrowserLog.low("准备播放 videoPlayer-prepareToPlay")
    }
    
    /// 播放状态改变
    func videoPlayer(_ videoPlayer: ZFPlayerController, playStateChanged state: ZFPlayerPlaybackState) {
        if state == .playStatePlaying {
            self.playBtnSelectedState(selected: true)
            if videoPlayer.currentPlayerManager.loadState == .stalled {
                self.activity.startAnimating()
            } else if videoPlayer.currentPlayerManager.loadState == .stalled  ||  videoPlayer.currentPlayerManager.loadState == .prepare {
                self.activity.startAnimating()
            }
        } else if state == .playStatePaused {
            self.playBtnSelectedState(selected: false)
            /// 暂停的时候隐藏loading
            self.activity.stopAnimating()
        } else if state == .playStatePlayFailed {
            self.activity.stopAnimating()
        } else if state == .playStatePlayStopped {
            self.activity.stopAnimating()
            self.playBtnSelectedState(selected: false)
        }
    }
    
    /// 加载状态改变
    func videoPlayer(_ videoPlayer: ZFPlayerController, loadStateChanged state: ZFPlayerLoadState) {
        if state == .prepare {
            self.coverImageView.isHidden = false
        } else if  state == .stalled &&  videoPlayer.currentPlayerManager.isPlaying {
            self.coverImageView.isHidden = true
            self.player?.currentPlayerManager.view.backgroundColor = .black
        }
        
        if state == .stalled && videoPlayer.currentPlayerManager.isPlaying  {
            self.activity.startAnimating()
        } else if (state == .stalled || state == .prepare) && videoPlayer.currentPlayerManager.isPlaying {
            self.activity.startAnimating()
        } else {
            self.activity.stopAnimating()
        }
    }
    
    func videoPlayer(_ videoPlayer: ZFPlayerController, currentTime: TimeInterval, totalTime: TimeInterval) {
        if (!self.slider.isdragging) {
            let currentTimeString = ZFUtilities.convertTimeSecond(NSInteger(currentTime))
            self.currentTimeLabel.text = currentTimeString;
            let totalTimeString = ZFUtilities.convertTimeSecond(NSInteger(totalTime))
            self.totalTimeLabel.text = totalTimeString
            self.slider.value = videoPlayer.progress
        }
        self.bottomPgrogress.value = videoPlayer.progress;
    }
    
    func videoPlayer(_ videoPlayer: ZFPlayerController, bufferTime: TimeInterval) {
        self.slider.bufferValue = videoPlayer.bufferProgress
        self.bottomPgrogress.bufferValue = videoPlayer.bufferProgress
    }
    
    
    func videoPlayer(_ videoPlayer: ZFPlayerController, presentationSizeChanged size: CGSize) {
        CMPhotoBrowserLog.low("准备播放 videoPlayer-presentationSizeChanged-size：\(size)")
    }
    
    /// 视频view即将旋转
    func videoPlayer(_ videoPlayer: ZFPlayerController, orientationWillChange observer: ZFOrientationObserver) {
        if (videoPlayer.isSmallFloatViewShow) {
            if (observer.isFullScreen) {
                self.controlViewAppeared = false
                cancelAutoFadeOutControlView()
            }
        }
        if (self.controlViewAppeared) {
            showControlView(animated: false)
        } else {
            hideControlView(animated: false)
        }
    }
    
    /// 视频view已经旋转
    func videoPlayer(_ videoPlayer: ZFPlayerController, orientationDidChanged observer: ZFOrientationObserver) {
        if (self.controlViewAppeared) {
           showControlView(animated: false)
        } else {
            hideControlView(animated: false)
        }
        self.layoutIfNeeded()
        self.setNeedsLayout()
    }
    
    /// 锁定旋转方向
    func lockedVideoPlayer(_ videoPlayer: ZFPlayerController, lockedScreen locked: Bool) {
        self.showControlView(animated: false)
    }
}

extension CMPhotoBrowserVideoControlView: ZFSliderViewDelegate {
    // 滑块滑动开始
    func sliderTouchBegan(_ value: Float) {
        self.slider.isdragging = true
    }

    // 滑块滑动结束
    func sliderTouchEnded(_ value: Float) {
        guard let player = self.player else {
            return
        }
        
        if player.totalTime > 0 {
            player.seek(toTime: player.totalTime * TimeInterval(value)
                        ) { [weak self] finish in
                if finish {
                    self?.slider.isdragging = false;
                }
            }
        } else {
            self.slider.isdragging = false
        }
    }
    
    // 滑块滑动中
    func sliderValueChanged(_ value: Float) {
        guard let player = self.player else {
            return
        }
        
        if (player.totalTime == 0) {
            self.slider.value = 0
            return
        }
        self.slider.isdragging = true
        let time = NSInteger(player.totalTime * Double(value))
        let currentTimeString = ZFUtilities.convertTimeSecond(time)
        self.currentTimeLabel.text = currentTimeString
    }
    
    // 滑杆点击
    func sliderTapped(_ value: Float) {
        guard let player = self.player else {
            return
        }
        
        if player.totalTime > 0 {
            self.slider.isdragging = true
            player.seek(toTime: player.totalTime * TimeInterval(value)) { [weak self] finish in
                if finish {
                    self?.slider.isdragging = false
                    player.currentPlayerManager.play()
                }
            }
        } else {
            self.slider.isdragging = false
            self.slider.value = 0
        }
        
    }
}
