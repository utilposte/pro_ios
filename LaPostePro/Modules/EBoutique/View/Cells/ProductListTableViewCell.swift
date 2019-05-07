//
//  ProductListTableViewCell.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 28/05/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit
import LPSharedMCM

protocol ProductCellDelegate: class {
    func addProductToCart(product: Product)
    func deleteProduct(product: Product)
}

class ProductListTableViewCell: UITableViewCell {

    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productDestinationAndWeightLabel: UILabel!
    @IBOutlet weak var productCategoryNameLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productAvailabilityLabel: UILabel!
    @IBOutlet weak var productAvailabilityLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var addToCartImageView: UIImageView!
    @IBOutlet weak var degressionLabel: UILabel!
    @IBOutlet weak var deleteProduct: UIButton!
    @IBOutlet weak var taxLabel: UILabel!
    
    
    // MARK: delegate for showing the toast
    weak var delegate: ProductCellDelegate?
    var product: Product?
    var productResponse: ProductResponse?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureCellWithProduct(product: Product, productViewModel: ProductViewModel) {
        self.product = product
        productNameLabel.text = product.name
        productDestinationAndWeightLabel.text = product.weightAndDestinationText
        productPriceLabel.text = product.price2?.replacingOccurrences(of: ".", with: ",")
        productAvailabilityLabel.text = product.availabilityLabel?.text
        productAvailabilityLabel.backgroundColor = product.availabilityLabel?.color
        degressionLabel.text = product.degressivity
        if (product.availabilityLabel != nil) {
            productAvailabilityLabelHeightConstraint.constant = (product.availabilityLabel?.height)!
            productAvailabilityLabel.text = product.availabilityLabel?.text
            productAvailabilityLabel.backgroundColor = product.availabilityLabel?.color
        }
        self.taxLabel.text = "Prix unit. \(product.taxClass ?? "NA")"
        
        if let imageUrl = product.imageUrl {
            productViewModel.loadProductImageView(url: imageUrl) { (image) in
                self.productImageView.image = image
            }
        }
        
        addToCartImageView.isUserInteractionEnabled = true
        addToCartImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addToCart)))
        if let isAvailable = product.isAvailable {
            if !isAvailable {
                addToCartImageView.isHidden = true
            }
        }
        
        deleteProduct.isHidden = true
    }
    
    func configureCellWithProductFavorites(product: Product, productViewModel: ProductViewModel) {
        let frandoleViewModel = FrandoleViewModel()
        self.product = frandoleViewModel.getFrandoleProduct(for: product)
        productNameLabel.text = product.name
        productDestinationAndWeightLabel.text = "\(product.sendingDestination?.name ?? "") \(String(describing:product.weight ?? 0) )g"        
        productPriceLabel.text = product.price2?.replacingOccurrences(of: ".", with: ",")
        productAvailabilityLabel.text = product.availabilityLabel?.text
        productAvailabilityLabel.backgroundColor = product.availabilityLabel?.color
        degressionLabel.text = product.degressivity
        if (product.availabilityLabel != nil) {
            productAvailabilityLabelHeightConstraint.constant = (product.availabilityLabel?.height)!
            productAvailabilityLabel.text = product.availabilityLabel?.text
            productAvailabilityLabel.backgroundColor = product.availabilityLabel?.color
        }
        
        if let imageUrl = product.imageUrl {
            productViewModel.loadProductImageView(url: imageUrl) { (image) in
                self.productImageView.image = image
            }
        }
        
        addToCartImageView.isUserInteractionEnabled = true
        addToCartImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addToCart)))
        if let isAvailable = product.isAvailable {
            if !isAvailable {
                addToCartImageView.isHidden = true
            }
        }
        
        deleteProduct.isHidden = false
    }
    
    @IBAction func deleteProductTapped(_ sender: Any) {
        self.delegate?.deleteProduct(product: self.product!)
    }
    
    @objc fileprivate func addToCart() {
        if self.delegate != nil {
            self.delegate?.addProductToCart(product: self.product!)
        }
    }
    override func prepareForReuse() {
        addToCartImageView.isHidden = false
    }
}
