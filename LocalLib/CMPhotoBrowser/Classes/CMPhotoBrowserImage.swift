//
//  CMPhotoBrowserImage.swift
//  Pods
//
//  Created by Allen on 2021/6/15.
//

import UIKit

class CMPhotoBrowserImage {
    
    static public func getImage(named: String, bundleName: String = "CMPhotoBrowser") -> UIImage? {
        let curBunld = Bundle(for: CMPhotoBrowser.classForCoder())
        if let curBundPath = curBunld.path(forResource: bundleName, ofType: "bundle"){
            let resourceBundle = Bundle(path: curBundPath)
            let img = UIImage(named: named, in: resourceBundle, compatibleWith: nil)
            if img != nil {
                return img
            }
            return UIImage(named: named)
        }
        return UIImage(named: named)
    }
    

}
