//
//  CMPhotoBrowserZoomSupportedCell.swift
//  CMVideoPhotoDemo
//
//  Created by Allen on 2021/6/13.
//

import UIKit

/// 在Zoom转场时使用
protocol CMPhotoBrowserZoomSupportedCell: UIView {
    /// 内容视图
    var showContentView: UIView { get }
}
