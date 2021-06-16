//
//  CMPhotoBrowserModel.swift
//  CMVideoPhotoDemo
//
//  Created by Allen on 2021/6/11.
//

import Foundation

public struct CMPhotoBrowserModel {
    enum SourceType {
        case video
        case image
    }
    
    var type: SourceType {
        get{
            guard let str = videoUrl else {
                return .image
            }
            
            if str.isEmpty == false && str.lowercased().contains(".mp4") {
                return .video
            }
            return .image
        }
    }
    
    var imgUrl: String
    var videoUrl: String?
    
   public init(imgUrl: String, videoUrl: String?) {
        self.imgUrl = imgUrl
        self.videoUrl = videoUrl
    }
}
