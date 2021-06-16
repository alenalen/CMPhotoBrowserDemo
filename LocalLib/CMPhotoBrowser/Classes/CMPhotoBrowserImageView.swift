//
//  CMPhotoBrowserImageView.swift
//  CMVideoPhotoDemo
//
//  Created by Allen on 2021/6/13.
//

import UIKit
import SDWebImage
import FLAnimatedImage

class CMPhotoBrowserImageView: FLAnimatedImageView {
    deinit {
        CMPhotoBrowserLog.low("deinit - \(self.classForCoder)-\(self.tag)")
    }

    var imageDidChangedHandler: (() -> ())?

    override var image: UIImage? {
        didSet {
            imageDidChangedHandler?()
        }
    }
    
    override var animatedImage: FLAnimatedImage? {
        didSet {
            imageDidChangedHandler?()
        }
    }

    func setImage(url: URL?, placeholderImage: UIImage?){
        self.sd_internalSetImage(with: url, placeholderImage: placeholderImage, options: SDWebImageOptions.init(rawValue: 0), context: nil) { [weak self] img, imageData, type, url in
            guard let image = img else {
                return
            }
            guard let strongSelf = self else { return }
            let imageFormat = NSData.sd_imageFormat(forImageData: imageData)
            if imageFormat == .GIF {
                DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                    let animatedImage = FLAnimatedImage(animatedGIFData: imageData)
                    DispatchQueue.main.async { [weak self] in
                        guard let strongSelf = self else { return }
                        // Set image in main queue
                        strongSelf.animatedImage = animatedImage
                        strongSelf.image = nil
                    }
                }
            } else {
                strongSelf.image = image
                strongSelf.animatedImage = nil
            }
        } progress: { a, b, url in
            
        } completed: { img, imageData, error, type, result, url in
            
        }
    }
}
