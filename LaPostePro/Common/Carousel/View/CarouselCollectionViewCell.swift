//
//  CarouselCollectionViewCell.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 07/05/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class CarouselCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var productAdditionalLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var sendModeLabel: UILabel!

    //used to apply some ui dpecification
    var contentType: ContentType?

    override func awakeFromNib() {
        productTitleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        productTitleLabel.textColor = .lpDeepBlue
        productTitleLabel.numberOfLines = 2
        productAdditionalLabel.font = UIFont.systemFont(ofSize: 13)
        productAdditionalLabel.textColor = .lpGrey
        productImageView.contentMode = .scaleAspectFit
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.clear.cgColor
        containerView.cornerRadius = 5
        //containerView.layer.masksToBounds = false
        containerView.layer
        .applyShadow(color: .lpGrayShadow, alpha: 1, x: 0, y: 2, blur: 20, spread: 0)
    }

    func setUpCell(with product: Product, and productViewModel: ProductViewModel) {
        productTitleLabel.text = product.name
        productAdditionalLabel.text = product.detail
        productPriceLabel.attributedText = productViewModel.getPriceText(for: contentType!, product: product)
        productViewModel.loadProductImageView(url: product.imageUrl!) { (productImage) in
            self.productImageView.image = productImage
        }
        if product.sendMode != nil {
            sendModeLabel.text = product.sendMode
        }
    }

}
