//
//  CMPhotoBrowserView.swift
//  CMVideoPhotoDemo
//
//  Created by Allen on 2021/6/11.
//

import Foundation
import UIKit
import ZFPlayer

class CMPhotoBrowserView: UIView {

    static let playViewTag: Int = 2000
    private let photoBrowserWidth = UIScreen.main.bounds.size.width
    
    lazy var dataSource = [CMPhotoBrowserModel]()
    lazy var index = 0

    /// 弱引用PhotoBrowser
    weak var photoBrowser: CMPhotoBrowser?

    lazy var layout:UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: photoBrowserWidth, height:  UIScreen.main.bounds.size.height)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0.0
        return layout
    }()
    
    
    lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(CMPhotoBrowserVideoCell.self, forCellWithReuseIdentifier: CMPhotoBrowserVideoCell.classForCoder().description())
        collection.register(CMPhotoBrowserImageCell.self, forCellWithReuseIdentifier: CMPhotoBrowserImageCell.classForCoder().description())
        collection.delegate = self
        collection.dataSource = self
        collection.bounces = true
        collection.isPagingEnabled = true
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        collection.backgroundColor = .clear
        return collection
    }()
    
    deinit {
        CMPhotoBrowserLog.low("deinit - \(self.classForCoder)")
    }
    
 
    init() {
        super.init(frame: .zero)
        setupUI()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        if #available(iOS 13.0, *) {
            collectionView.automaticallyAdjustsScrollIndicatorInsets = false
        } else {

        }
        addSubview(collectionView)
    }
    
    private func makeConstraints()  {
        self.collectionView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.collectionView.frame = CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height)
    }
    
    func reloadData()  {
        if self.dataSource.count == 0 {
            return
        }
        
        if index >= self.dataSource.count {
            self.collectionView.reloadData()
            return
        }
        //self.collectionView.reloadData()

//        self.collectionView.reloadData()
//        DispatchQueue.main.asyncAfter(deadline: .now()+0.01) {
//            self.collectionView.setContentOffset(CGPoint(x: self.photoBrowserWidth * CGFloat(self.index), y: 0), animated: false)
//        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.01) {
            self.collectionView.layoutIfNeeded()
            let indexPath = IndexPath(row: self.index, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
        }
        
    }
}


extension CMPhotoBrowserView: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = self.dataSource[indexPath.item]
        if model.type == .image {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CMPhotoBrowserImageCell.self.description(), for: indexPath) as! CMPhotoBrowserImageCell
            cell.index = indexPath.item
            cell.photoBrowser = photoBrowser
            cell.imgeViewUrl = model.imgUrl
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CMPhotoBrowserVideoCell.self.description(), for: indexPath) as! CMPhotoBrowserVideoCell
        cell.index = indexPath.item
        cell.photoBrowser = photoBrowser
        cell.photoBrowserView = self
        cell.model = model
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        CMPhotoBrowserLog.low("willDisplay:\(cell),hide:\(cell.isHidden)")
        if (cell as? CMPhotoBrowserVideoCell)?.index == self.index {
            (cell as? CMPhotoBrowserVideoCell)?.playUrl(nil,isNeedPlay: true)
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        CMPhotoBrowserLog.low("didEndDisplaying:\(cell),hide:\(cell.isHidden)")
        (cell as? CMPhotoBrowserVideoCell)?.stopPlayer()
    }

//    //MARK: - UIScrollViewDelegate  列表播放必须实现
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//
//    }
//
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//
//    }
//
//    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
//
//    }
//
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
////        let cells = self.collectionView.visibleCells
////        for cell in cells {
////            (cell as? CMPhotoBrowserVideoCell)?.stopPlayer()
////        }
//    }
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        //CMPhotoBrowserLog.low("scrollView.contentOffset.x:\(scrollView.contentOffset.x),scrollView.contentOffset.y:\(scrollView.contentOffset.y)")
//    }
    
}
