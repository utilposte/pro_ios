//
//  SearchProductCell.swift
//  LaPostePro
//
//  Created by Matthieu Lemonnier on 24/09/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit


class SearchProductCell: UITableViewCell {

    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productDestinationAndWeightLabel: UILabel!
    @IBOutlet weak var productCategoryNameLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productAvailabilityLabel: UILabel!
    @IBOutlet weak var productAvailabilityLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var addToCartImageView: UIImageView!
    @IBOutlet weak var degressionLabel: UILabel!
    

    // MARK: delegate for showing the toast
    weak var delegate: ProductCellDelegate?
    var product: Product?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCellWithProduct(product: Product, productViewModel: ProductViewModel) {
        self.product = product
        productNameLabel.text = product.name
        productDestinationAndWeightLabel.text = product.weightAndDestinationText
        productPriceLabel.text = product.price?.formattedValue
        productAvailabilityLabel.text = product.availabilityLabel?.text
        productAvailabilityLabel.backgroundColor = product.availabilityLabel?.color
        degressionLabel.text = product.degressivity
        if (product.availabilityLabel != nil) {
            productAvailabilityLabelHeightConstraint.constant = (product.availabilityLabel?.height)!
            productAvailabilityLabel.text = product.availabilityLabel?.text
            productAvailabilityLabel.backgroundColor = product.availabilityLabel?.color
        }
        productViewModel.loadProductImageView(url: product.imageUrl ?? "") { (image) in
            self.productImageView.image = image
        }
        addToCartImageView.isUserInteractionEnabled = true
        addToCartImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addToCart)))
        if !(product.isAvailable ?? false) {
            addToCartImageView.isHidden = true
        }
    }
    
    @objc fileprivate func addToCart() {
        if self.delegate != nil {
            self.delegate?.addProductToCart(product: self.product!)
        }
    }
    override func prepareForReuse() {
        addToCartImageView.isHidden = false
    }
    
    class func getCell() -> SearchProductCell? {
        let nibArray = Bundle.main.loadNibNamed("SearchProductCell", owner: self, options: nil)
        let cell = nibArray?.first as? SearchProductCell
        return cell
    }
    
}
