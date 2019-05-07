//
//  ProductGalleryViewController.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 13/06/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class ProductGalleryViewController: UIViewController {
    @IBOutlet weak var zoomScrollView: UIScrollView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    
    @IBOutlet weak var closeImageView: UIImageView!
    @IBOutlet weak var productImageGalleryCollectionView: UICollectionView!
    @IBOutlet weak var productImageView: UIImageView!
    var imageList: [UIImage]?
    var productName: String?
    var selectedImageIndex = 1
    var productCollectionViewImageList = [ProductCollectionViewImage]()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        addGestureRecognize()
        createDataSourceList()
        productNameLabel.text = productName
        self.collectionView(productImageGalleryCollectionView, didSelectItemAt: IndexPath(row: selectedImageIndex, section: 0))
        zoomScrollView.delegate = self
        
        NotificationCenter.default.addObserver(forName: statusBarTappedNotification.name, object: .none, queue: .none) { _ in
            self.dismiss(animated: true, completion: nil)
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // ATInternet
        ATInternetTaggingManager.sharedManager.sendTrackPage(pageName: productNameLabel.text!,
                                                             chapter1: TaggingData.kProductDetails,
                                                             chapter2: TaggingData.kZoom,
                                                             level2: TaggingData.kCommerceLevel)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }

    private func configureCollectionView() {
        self.productImageGalleryCollectionView.delegate = self
        self.productImageGalleryCollectionView.dataSource = self
        self.productImageGalleryCollectionView.showsHorizontalScrollIndicator = false
    }

    private func addGestureRecognize() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeImageClicked))
        closeImageView.isUserInteractionEnabled = true
        closeImageView.addGestureRecognizer(tapGesture)
        //add gesture recognizer to close view controller
        let swipeToDown = UISwipeGestureRecognizer(target: self, action: #selector(closeImageClicked))
        swipeToDown.direction = .down
        self.view.addGestureRecognizer(swipeToDown)
        //add gesture recognizer to change image in gallery
        let swipeToLeft = UISwipeGestureRecognizer(target: self, action: #selector(goToNextImage))
        swipeToLeft.direction = .left
        let swipeToRight = UISwipeGestureRecognizer(target: self, action: #selector(goToPreviousImage))
        swipeToRight.direction = .right
        self.view.addGestureRecognizer(swipeToLeft)
        self.view.addGestureRecognizer(swipeToRight)
    }
    fileprivate func createDataSourceList() {
        for image in imageList! {
            productCollectionViewImageList.append(ProductCollectionViewImage.init(image: image))
        }
        productCollectionViewImageList = productCollectionViewImageList.reversed()
        if !productCollectionViewImageList.isEmpty {
            self.productImageView.image = productCollectionViewImageList.first!.image
        }
    }
}

extension ProductGalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productCollectionViewImageList.count + 2
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 || indexPath.row > productCollectionViewImageList.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmptyCollectionViewCellID", for: indexPath)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductGalleryCollectionViewCellID", for: indexPath) as! ProductGalleryCollectionViewCell
            cell.setupCell(productCollectionViewImage: productCollectionViewImageList[indexPath.row - 1])
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row != 0 && indexPath.row <= productCollectionViewImageList.count {
            selectedImageIndex = indexPath.row
            collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
            self.productImageView.image = productCollectionViewImageList[indexPath.row - 1].image!
            productCollectionViewImageList = ProductGalleryViewModel().setOverLayForAllCell(productCollectionViewImages: productCollectionViewImageList)
            productCollectionViewImageList[indexPath.row - 1].highlited = true
            collectionView.reloadData()
            zoomScrollView.zoomScale = 1
        }
    }
    @objc fileprivate func closeImageClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 || indexPath.row > productCollectionViewImageList.count {
            return CGSize(width: (UIScreen.main.bounds.width / 2) - 25, height: collectionView.bounds.height)
        } else {
            return CGSize(width: 50, height: collectionView.bounds.height)
        }
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.productImageView
    }

    @objc fileprivate func goToNextImage() {
        if selectedImageIndex < productCollectionViewImageList.count {
            let nextImageIndexPath = IndexPath(row: selectedImageIndex + 1, section: 0)
            self.collectionView(productImageGalleryCollectionView, didSelectItemAt: nextImageIndexPath)
        }
    }

    @objc fileprivate func goToPreviousImage() {
        if selectedImageIndex > 1 {
            let previousImageIndexPath = IndexPath(row: selectedImageIndex - 1, section: 0)
            self.collectionView(productImageGalleryCollectionView, didSelectItemAt: previousImageIndexPath)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let point = touch.location(in: self.view)
            
            let receiverView = view.hitTest(point, with: event)
            if (receiverView != contentView) && (receiverView != headerView){
                dismiss(animated: true, completion: nil)
            }
        }
    }
}
