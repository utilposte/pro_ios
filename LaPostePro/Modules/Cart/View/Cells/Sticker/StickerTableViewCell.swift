//
//  StickerTableViewCell.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 27/06/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit
import LPSharedMCM

protocol ReconditioningCellDelegate: class {
    func applyReconditioning(products: [Product])
    func removeReconditioningCell(cell: UITableViewCell)
}


class StickerTableViewCell: UITableViewCell {

    @IBOutlet weak var firstProductNameLabel: UILabel!
    @IBOutlet weak var firstProductWeightAndDestinationLabel: UILabel!
    @IBOutlet weak var firstProductImageView: UIImageView!
    @IBOutlet weak var firstProductQuantityLabel: UILabel!
    @IBOutlet weak var firstProductPriceLabel: UILabel!

    @IBOutlet weak var secondProductNameLabel: UILabel!
    @IBOutlet weak var secondProductWeightAndDestinationLabel: UILabel!
    @IBOutlet weak var secondProductImageView: UIImageView!
    @IBOutlet weak var secondProductQuantityLabel: UILabel!
    @IBOutlet weak var secondProductPriceLabel: UILabel!

    @IBOutlet weak var thirdProductNameLabel: UILabel!
    @IBOutlet weak var thirdProductWeightAndDestinationLabel: UILabel!
    @IBOutlet weak var thirdProductImageView: UIImageView!
    @IBOutlet weak var thirdProductQuantityLabel: UILabel!
    @IBOutlet weak var thirdProductPriceLabel: UILabel!

    @IBOutlet weak var dontApplyReconditioningButton: UIButton!

    @IBOutlet weak var separatorSecondAndThirdProductConstraint: NSLayoutConstraint!
    @IBOutlet weak var separatorFirstAndSecondProductConstraint: NSLayoutConstraint!
    @IBOutlet weak var thirdProductContainerView: UIView!
    @IBOutlet weak var secondProductContainerView: UIView!
    @IBOutlet weak var firstProductContainerView: UIView!
    @IBOutlet weak var buttonsContainerView: UIView!
    @IBOutlet weak var thirdStickerProductViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var secondStickerProductViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var applyReconditioningButton: UIButton!
    
    enum crossSellingIndexCell: Int {
        case first = 0
        case second
        case third
    }
    
    private var totalCountStricker: Int?
    weak var delegate: ReconditioningCellDelegate?
    private var productArray: [Product]?
    override func awakeFromNib() {
        super.awakeFromNib()
        applyReconditioningButton.cornerRadius = applyReconditioningButton.frame.height / 2
        dontApplyReconditioningButton.cornerRadius = dontApplyReconditioningButton.frame.height / 2
        
        firstProductContainerView.cornerRadius = 5
        secondProductContainerView.cornerRadius = 5
        thirdProductContainerView.cornerRadius = 5
    }
    
    func configure() {
         self.productArray = CartViewModel.sharedInstance.getReconditionningProductFromCart()
        buttonsContainerView.layer.applyShadow(color: .lpGrayShadow, alpha: 1, x: -3, y: 3, blur: 15, spread: 0)
        switch productArray?.count {
        case 1:
            setupOneCell()
            ProductViewModel().getProduct(withID: productArray![0].id!) { (hybProduct) in
                let product1 = Product.init(hybProduct: hybProduct)
                product1.quantityInCart = self.productArray![0].quantityInCart
                self.setupWithOneProduct(product: product1)
            }
            
        case 2:
            setupTwoCell()
            for product in productArray! {
                ProductViewModel().getProduct(withID: product.id!) { (hybProduct) in
                    let product1 = Product.init(hybProduct: hybProduct)
                    product1.quantityInCart = self.productArray![(self.productArray?.index(where: { product1.id == $0.id }))!].quantityInCart//product.quantityInCart
                    self.productArray![(self.productArray?.index(where: { product1.id == $0.id }))!] = product1
                    self.setupWithTwoProduct(products: self.productArray!)
                }
            }
        default:
            for product in productArray! {
                ProductViewModel().getProduct(withID: product.id!) { (hybProduct) in
                    let product1 = Product.init(hybProduct: hybProduct)
                    product1.quantityInCart = self.productArray![(self.productArray?.index(where: { product1.id == $0.id }))!].quantityInCart//product.quantityInCart
                    self.productArray![(self.productArray?.index(where: { product1.id == $0.id }))!] = product1
                    self.setupWithThreeProducts(products: self.productArray!)
                }
            }
        }
    }


    @IBAction func applyReconditioningButtonClicked(_ sender: Any) {
        if delegate != nil {
            delegate?.applyReconditioning(products: self.productArray!)
        }
    }
    @IBAction func dontApplyReconditioningButtonClicked(_ sender: Any) {
        if delegate != nil {
            delegate?.removeReconditioningCell(cell: self)
        }
    }
    
    private func setupOneCell() {
        secondProductContainerView.clipsToBounds = true
        thirdProductContainerView.clipsToBounds = true
        secondStickerProductViewHeightConstraint.constant = 0
        thirdStickerProductViewHeightConstraint.constant = 0
        separatorFirstAndSecondProductConstraint.constant = 0
        separatorSecondAndThirdProductConstraint.constant = 0
    }
    
    private func setupTwoCell() {
        thirdProductContainerView.clipsToBounds = true
        thirdStickerProductViewHeightConstraint.constant = 0
        separatorSecondAndThirdProductConstraint.constant = 0
    }
    
    private func setupWithOneProduct(product: Product) {
        configureCell(with: product, and: .first)
    }
    
    private func setupWithTwoProduct(products: [Product]) {
        configureCell(with: products[0], and: .first)
        configureCell(with: products[1], and: .second)
    }
    
    private func setupWithThreeProducts(products: [Product]) {
        configureCell(with: products[0], and: .first)
        configureCell(with: products[1], and: .second)
        configureCell(with: products[2], and: .third)
    }
    
    private func configureCell(with product: Product, and index: crossSellingIndexCell) {
        switch index {
        case .first:
            firstProductContainerView.layer.applyShadow(color: .lpGrayShadow, alpha: 1, x: -3, y: 3, blur: 15, spread: 0)
            firstProductImageView.contentMode = .scaleAspectFit
            firstProductNameLabel.text = product.name
            firstProductWeightAndDestinationLabel.text = product.weightAndDestinationText
            firstProductPriceLabel.text = product.price2
            firstProductQuantityLabel.text = String(format: "x%@", (product.quantityInCart?.stringValue)!)
            if product.imagesUrlList?[0] != nil {
                ProductViewModel().loadProductImageView(url: (product.imagesUrlList?.last)!) { (image) in
                    self.firstProductImageView.image = image
                }
            }
            break
        case .second:
            secondProductContainerView.layer.applyShadow(color: .lpGrayShadow, alpha: 1, x: -3, y: 3, blur: 15, spread: 0)
            secondProductImageView.contentMode = .scaleAspectFit
            secondProductNameLabel.text = product.name
            secondProductWeightAndDestinationLabel.text = product.weightAndDestinationText
            secondProductPriceLabel.text = product.price2
            secondProductQuantityLabel.text = String(format: "x%@", (product.quantityInCart?.stringValue)!)
            if product.imagesUrlList?.last != nil {
                ProductViewModel().loadProductImageView(url: product.imagesUrlList!.last!) { (image) in
                    self.secondProductImageView.image = image
                }
            }
            break
            case .third:
                thirdProductContainerView.layer.applyShadow(color: .lpGrayShadow, alpha: 1, x: -3, y: 3, blur: 15, spread: 0)
                thirdProductImageView.contentMode = .scaleAspectFit
                thirdProductNameLabel.text = product.name
                thirdProductWeightAndDestinationLabel.text = product.weightAndDestinationText
                thirdProductPriceLabel.text = product.price2
                thirdProductQuantityLabel.text = String(format: "x%@", (product.quantityInCart?.stringValue)!)
                if product.imagesUrlList?.last != nil {
                    ProductViewModel().loadProductImageView(url: product.imagesUrlList!.last!) { (image) in
                        self.thirdProductImageView.image = image
                    }
                }
            break
        }
    }
}

