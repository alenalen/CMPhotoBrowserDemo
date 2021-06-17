//
//  ViewController.swift
//  CMPhotoBrowserDemo
//
//  Created by Allen on 2021/6/15.
//

import UIKit
import CMPhotoBrowser


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    lazy var data: [CMPhotoBrowserModel] = {
        var da = [CMPhotoBrowserModel]()
        
        
//        if let url0 = Bundle.main.url(forResource: "1111", withExtension: "gif") {
//            let mod = CMPhotoBrowserModel(imgUrl: url0.absoluteString, videoUrl: nil)
//            da.append(mod)
//        }
        
//        let mod4 = CMPhotoBrowserModel(imgUrl: "http://ww3.sinaimg.cn/bmiddle/7ef8e115jw1f972pb91fng206o06odqk.gif", videoUrl: nil)
//        da.append(mod4)
        
        let mod1 = CMPhotoBrowserModel(imgUrl: "https://wx3.sinaimg.cn/mw690/6852466cly1gjxxryaucnj216o1ryhdt.jpg", videoUrl: nil)
        da.append(mod1)
        
        
        let mod5 = CMPhotoBrowserModel(imgUrl: "https://dev-cdn-common.codemao.cn/test/266/teaching/medal/certificate/1616132096_745985c3-b78e-456f-951b-f158fcbf052f_227.jpg", videoUrl: "https://www.apple.com/105/media/cn/mac/family/2018/46c4b917_abfd_45a3_9b51_4e3054191797/films/bruce/mac-bruce-tpl-cn-2018_1280x720h.mp4")
        da.append(mod5)
       
        if let url0 = Bundle.main.url(forResource: "video_0", withExtension: "MP4") {
            let mod = CMPhotoBrowserModel(imgUrl: "https://wx2.sinaimg.cn/mw690/6852466cly1gjxxru82uij216o1ryx4c.jpg", videoUrl: url0.absoluteString)
            da.append(mod)
        }

        let mod2 = CMPhotoBrowserModel(imgUrl: "https://wx2.sinaimg.cn/mw1024/006II2JPgy1gjzg9bh7w6j33402c0x6q.jpg", videoUrl: nil)
        da.append(mod2)

        if let url1 = Bundle.main.url(forResource: "video_1", withExtension: "MP4") {
            let mod = CMPhotoBrowserModel(imgUrl: "http://wx3.sinaimg.cn/bmiddle/005FAKE1gy1ffxgx6rur3j30qo140q7t.jpg", videoUrl: url1.absoluteString)
            da.append(mod)
        }

        let mod3 = CMPhotoBrowserModel(imgUrl: "http://wx3.sinaimg.cn/bmiddle/b0af402fgy1ffwuzdav8xj20qo13w789.jpg", videoUrl: nil)
        da.append(mod3)

        if let url2 = Bundle.main.url(forResource: "video_2", withExtension: "MP4") {
            let mod = CMPhotoBrowserModel(imgUrl: "https://wx4.sinaimg.cn/mw1024/c260f7abgy1ghdf9fk362j21xg2h9u0z.jpg", videoUrl: url2.absoluteString)
            da.append(mod)
        }
        
        
        return da
    }()

    @IBAction func showAction(_ sender: Any) {
        CMPhotoBrowser.show(self, dataSource: self.data, index: 3)
    }
    
}

