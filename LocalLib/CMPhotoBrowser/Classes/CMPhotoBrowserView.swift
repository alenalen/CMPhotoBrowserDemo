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
    
    lazy var dataSource = [CMPhotoBrowserModel]()
    
    /// 弱引用PhotoBrowser
    weak var photoBrowser: CMPhotoBrowser?
    
    lazy var layout:UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.size.width, height:  UIScreen.main.bounds.size.height)
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
        addSubview(collectionView)
    }
    
    private func makeConstraints()  {
        self.collectionView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.collectionView.frame = CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height)
    }
    
    func reloadData(_ dataSource: [CMPhotoBrowserModel])  {
        self.dataSource = dataSource
        self.collectionView.reloadData()
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
        cell.videoUrl = model.videoUrl
        cell.imgeViewUrl = model.imgUrl
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        CMPhotoBrowserLog.low(cell)
    }

    //MARK: - UIScrollViewDelegate  列表播放必须实现
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        scrollView.zf_scrollViewDidEndDecelerating()
    }
        
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        scrollView.zf_scrollViewDidEndDraggingWillDecelerate(decelerate)
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
//        scrollView.zf_scrollViewDidScrollToTop()

    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        scrollView.zf_scrollViewWillBeginDragging()
        let cells = self.collectionView.visibleCells
        for cell in cells {
            (cell as? CMPhotoBrowserVideoCell)?.stopPlayer()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        scrollView.zf_scrollViewDidScroll()
    }
    
}
