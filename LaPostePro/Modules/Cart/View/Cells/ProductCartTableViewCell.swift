//
//  ProductCartTableViewCell.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 09/05/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

protocol ProductCartTableViewCellDelegate: class {
    func didDeletedProduct(index: Int)
    func didUpdateProductQuantity()
}

class ProductCartTableViewCell: UITableViewCell {

    // MARK: Properties
    //var indexPath: IndexPath?
    var product: Product?

    // MARK: IBOutlets
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var productDescLabel: UILabel!
    @IBOutlet weak var additionalInfoLabel: UILabel!
    @IBOutlet weak var priceHTLabel: UILabel!
    @IBOutlet weak var priceHTInfoLabel: UILabel!
    @IBOutlet weak var priceTTCLabel: UILabel!
    @IBOutlet weak var priceTTCInfoLabel: UILabel!
    @IBOutlet weak var unitPriceHTLabel: UILabel!
    @IBOutlet weak var stepperView: Stepper!
    @IBOutlet weak var priceView: UIView!
    
    @IBOutlet weak var heightCellConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightPriceViewConstraint: NSLayoutConstraint!
    
    
    // MARK: Delegate
    weak var delegate: ProductCartTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    internal func configureProductCartCell(product: Product) {
        self.stepperView.delegate = self
        
        self.stepperView.isHidden = false
        self.priceView.isHidden = false
        self.heightCellConstraint.constant = 235
        self.heightPriceViewConstraint.constant = 50
        
        self.product = product
        //self.indexPath = IndexPath.init(row: indexPath.row, section: indexPath.section)
        self.productTitleLabel.text = product.name
        
        let quantity = Int(truncating: product.quantityInCart!)
        self.stepperView.setQuantity(quantity: quantity)
        
        if let priceHT = product.totalNetPrice {
            self.priceHTLabel.text = priceHT.replacingOccurrences(of: ".", with: ",")
        }
        
        if let priceTTC = product.totalPrice {
            self.priceTTCLabel.text = priceTTC.replacingOccurrences(of: ".", with: ",")
        }
        
        if let priceUnit = product.baseNetPrice {
            let priceUnitFormatted = priceUnit.replacingOccurrences(of: ".", with: ",")
            self.unitPriceHTLabel.text = priceUnitFormatted + " prix unitaire " + product.taxClass!
        }

        //Need refoctoring!
        let productViewModel = ProductViewModel()
        if product.imageUrl != nil {
            productViewModel.loadProductImageView(url: product.imageUrl!) { (productImage) in
                self.productImageView.image = productImage
            }
        }
    }

    @IBAction func removeProduct(_ sender: UIButton) {
        // TODO MLE CHANGE
        if self.product != nil && self.product!.entryNumber != nil {
            delegate?.didDeletedProduct(index: self.product!.entryNumber!)
        }        
    }

}

extension ProductCartTableViewCell: StepperDelegate {
    func stepperTextFieldBegginEditing() {
    }
    
    func quantityChange(quantity: String, quantityHandler: QuantityHandler) {

        CartViewModel.sharedInstance.updateQuantity(for: self.product!, quantity: Int(quantity)!) { (_) in
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "update_cart")))
            //product?.quantityInCart = quantity as NSNumber
            self.delegate?.didUpdateProductQuantity()
        }
    }

    func stepperTextFieldShouldReturn() {

    }

}
