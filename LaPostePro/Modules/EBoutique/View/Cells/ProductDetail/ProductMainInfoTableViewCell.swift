//
//  ProductMainInfoTableViewCell.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 12/06/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

protocol ProductDetailDelegate: class {
    func openGallery(with images: [UIImage])
    func changeFeaturesListSize()
    func shareProduct()
}

class ProductMainInfoTableViewCell: UITableViewCell {
    @IBOutlet weak var imageSliderPageController: UIPageControl!
    @IBOutlet weak var imageSlideScrollView: UIScrollView!
    @IBOutlet weak var productShortDescriptionLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productRefLabel: UILabel!
    var productImageList: [UIImage]?
    weak var delegate: ProductDetailDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageSliderPageController.numberOfPages = 0
    }

    func setUpCell(productDetailViewModel: ProductDetailViewModel) {
        for subview in imageSlideScrollView.subviews {
            subview.removeFromSuperview()
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openProductGallery))
        imageSlideScrollView.addGestureRecognizer(tapGesture)
        // TODOs: set use of hybris product in modelview
        productShortDescriptionLabel.text = productDetailViewModel.product?.summary.htmlToString
        productNameLabel.text = productDetailViewModel.product?.name
        productRefLabel.text = String(format: "Ref: %@", (productDetailViewModel.product?.code)!)
        productDetailViewModel.createImageArrayForSlider { imageList in
            self.productImageList = imageList
            self.imageSlideScrollView.delegate = self
            self.imageSlideScrollView.showsHorizontalScrollIndicator = false
            var countIndex = CGFloat(0)
            for image in imageList {
                let imageView = UIImageView(image: image)
                imageView.isUserInteractionEnabled = true
                imageView.frame = CGRect(x: countIndex * self.imageSlideScrollView.frame.width, y: 0, width: self.imageSlideScrollView.frame.width, height: self.imageSlideScrollView.frame.height)
                imageView.contentMode = .scaleAspectFit
                self.imageSlideScrollView.addSubview(imageView)
                countIndex += 1
            }
            self.self.imageSlideScrollView.contentSize = CGSize(width: self.imageSlideScrollView.frame.width * countIndex, height: self.imageSlideScrollView.frame.height)
            self.imageSlideScrollView.isPagingEnabled = true
            self.imageSliderPageController.numberOfPages = imageList.count > 1 ? imageList.count : 0
            self.imageSliderPageController.customPageControl(dotFillColor: .lpPurple, dotBorderColor: .lpGrey, dotBorderWidth: 1)
        }
    }

    @objc func openProductGallery() {
        if delegate != nil {
            delegate?.openGallery(with: self.productImageList!)
        }
    }
}

extension ProductMainInfoTableViewCell: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        imageSliderPageController.currentPage = Int(floor(scrollView.contentOffset.x / scrollView.frame.size.width))
        imageSliderPageController.customPageControl(dotFillColor: .lpPurple, dotBorderColor: .lpGrey, dotBorderWidth: 1)
    }
}
