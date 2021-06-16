//
//  CMPhotoBrowserLog.swift
//  CMVideoPhotoDemo
//
//  Created by Allen on 2021/6/13.
//

import Foundation

public struct CMPhotoBrowserLog {
    
    /// 日志重要程度等级
    public enum Level: Int {
        case low = 0
        case middle
        case high
        case forbidden
    }
    
    /// 允许输出日志的最低等级。`forbidden`为禁止所有日志
    public static var level: Level = .forbidden
    
    public static func low(_ item: @autoclosure () -> Any) {
        if level.rawValue <= Level.low.rawValue {
            print("[CMPhotoBrowser] [low]", item())
        }
    }
    
    public static func middle(_ item: @autoclosure () -> Any) {
        if level.rawValue <= Level.middle.rawValue {
            print("[CMPhotoBrowser] [middle]", item())
        }
    }
    
    public static func high(_ item: @autoclosure () -> Any) {
        if level.rawValue <= Level.high.rawValue {
            print("[CMPhotoBrowser] [high]", item())
        }
    }
}

