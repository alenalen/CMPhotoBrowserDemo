//
//  CMPhotoBrowserAnimatedTransitioning.swift
//  CMVideoPhotoDemo
//
//  Created by Allen on 2021/6/12.
//

import Foundation
import UIKit


public protocol CMPhotoBrowserAnimatedTransitioning: UIViewControllerAnimatedTransitioning {
    var isForShow: Bool { get set }
    var photoBrowser: CMPhotoBrowser? { get set }
    var isNavigationAnimation: Bool { get set }
}

private var isForShowKey = "isForShowKey"
private var photoBrowserKey = "photoBrowserKey"

extension CMPhotoBrowserAnimatedTransitioning {
    
    public var isForShow: Bool {
        get {
            if let value = objc_getAssociatedObject(self, &isForShowKey) as? Bool {
                return value
            }
            return true
        }
        set {
            objc_setAssociatedObject(self, &isForShowKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    public weak var photoBrowser: CMPhotoBrowser? {
        get {
            return objc_getAssociatedObject(self, &photoBrowserKey) as? CMPhotoBrowser
        }
        set {
            objc_setAssociatedObject(self, &photoBrowserKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    public var isNavigationAnimation: Bool {
        get { return false }
        set { }
    }
    
    public func fastSnapshot(with view: UIView) -> UIView? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: false)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return UIImageView(image: image)
    }
    
    public func snapshot(with view: UIView) -> UIView? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        view.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return UIImageView(image: image)
    }
}
