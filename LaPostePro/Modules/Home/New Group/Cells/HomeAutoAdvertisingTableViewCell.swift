//
//  HomeAutoAdvertisingTableViewCell.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 11/05/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class HomeAutoAdvertisingTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productDestinationAndWeightLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var promotionCauseLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!

    var productViewModel = ProductViewModel()

    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.addBorder(withColor: UIColor.lpGrayShadow.cgColor, andThickness: 1, andCornerRaduis: 5)
    }

    func setupCell(with product: Product) {
        productNameLabel.text = product.name
        productDestinationAndWeightLabel.text = product.detail
        productPriceLabel.attributedText = productViewModel.getPriceText(for: .favoritesList, product: product)
        productViewModel.loadProductImageView(url: product.imageUrl!) { (productImage) in
            self.productImageView.image = productImage
        }
        promotionCauseLabel.attributedText = productViewModel.getPromotionCause(product: product)
    }

}
