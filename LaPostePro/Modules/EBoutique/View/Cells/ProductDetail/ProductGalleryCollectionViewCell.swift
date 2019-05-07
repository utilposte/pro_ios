//
//  ProductGalleryCollectionViewCell.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 13/06/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class ProductGalleryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var overlayView: UIView!

    func setupCell(productCollectionViewImage: ProductCollectionViewImage) {
        overlayView.isHidden = productCollectionViewImage.highlited
        productImageView.contentMode = .scaleAspectFit
        productImageView.image = productCollectionViewImage.image!
        productImageView.layer.borderColor = UIColor.lpGrey.cgColor
        productImageView.layer.borderWidth = 1
        productImageView.layer.cornerRadius = 3
    }
}
