//
//  FLAnimatedImageView+Codemao.swift
//  CMPhotoBrowserDemo
//
//  Created by Allen on 2021/6/16.
//
import FLAnimatedImage
import SDWebImageFLPlugin

extension FLAnimatedImageView {
    func setImage(with url: URL?, placeholderImage: UIImage?) {
        self.sd_internalSetImage(with: url, placeholderImage: placeholderImage, options: SDWebImageOptions.init(rawValue: 0), context: nil) { [weak self] img, imageData, type, url in
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
                // Set image in main queue
                strongSelf.image = img
                strongSelf.animatedImage = nil
            }
            
        } progress: { a, b, url in
            
        } completed: { img, imageData, error, type, result, url in
            
        }
        
    }
}
