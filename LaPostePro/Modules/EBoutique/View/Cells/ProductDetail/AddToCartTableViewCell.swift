//
//  AddToCartTableViewCell.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 21/06/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit
enum StockStatus {
    case inStock
    case outOfStock
    case lowStock
}

protocol AddToCartCellDelegate: class {
    func scrollToCell(cell: UITableViewCell)
    func addToCartButtonTapped(cell: AddToCartTableViewCell)
    func displayAlertForAvailabilityNotifictation()
}
class AddToCartTableViewCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var stepperView: Stepper!
    @IBOutlet weak var cellButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var unavailabilityAlertLabel: UILabel!
    @IBOutlet weak var availabilityInfoView: UIView!
    @IBOutlet weak var stockLevelLabel: UIButton!
    @IBOutlet weak var availabilityViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var stepperTitleLabel: UILabel!
    var stockStatus: StockStatus?
    weak var delegate: AddToCartCellDelegate?
    //private var product: Product?
    var productDetailViewModel: ProductDetailViewModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        configureCell()
    }

    func setupCell(with productDetailViewModel: ProductDetailViewModel) {
        // check for iphone 5, 5C ou SE
        if UIScreen.main.bounds.size.height == 1136 {
            cellButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        }
        self.stockStatus = productDetailViewModel.getStockStatus()
        self.productDetailViewModel = productDetailViewModel
        setupCellButton(title: productDetailViewModel.getCellButtonText(stockStatus: stockStatus!), color: productDetailViewModel.getCellButtonBackgroundColor(stockStatus: stockStatus!), icon: productDetailViewModel.getCellButtonIcon(stockStatus: stockStatus!))
        self.priceLabel.attributedText = productDetailViewModel.getPriceFormattedAttributtedText()
        setupAvailabilityView(with: productDetailViewModel.getAvailibilityLabel(stockStatus: stockStatus!))
        self.unavailabilityAlertLabel.text = productDetailViewModel.getUnavailabilityAlertText(stockStatus: stockStatus!)
        switch stockStatus! {
        case .outOfStock:
            stepperTitleLabel.alpha = 0.5
            stepperView.disableStepper()
        default:
            stepperView.alpha = 1
        }
    }

    fileprivate func setupAvailabilityView(with availabilityLabel: AvailabilityLabel) {
        availabilityViewHeightConstraint.constant = availabilityLabel.height ?? 0
        stockLevelLabel.setTitle(availabilityLabel.text, for: .normal)
        availabilityInfoView.backgroundColor = availabilityLabel.color
    }

    fileprivate func configureCell() {
        containerView.cornerRadius = 5
        containerView.clipsToBounds = false
        containerView.layer.applyShadow(color: .lpGrayShadow, alpha: 1, x: 0, y: 2, blur: 20, spread: 0)
        cellButton.cornerRadius = cellButton.layer.frame.height / 2
        stepperView.delegate = self
        stepperView.setQuantity(quantity: 1)
    }

    fileprivate func setupCellButton(title: String, color: UIColor, icon: UIImage?) {
        cellButton.setTitle(title, for: .normal)
        cellButton.backgroundColor = color
        cellButton.setImage(icon?.withRenderingMode(.alwaysOriginal), for: .normal)
        if icon != nil {
            cellButton.titleEdgeInsets.left = 15
        } else {
            cellButton.titleEdgeInsets.left = 0
        }
    }

    @IBAction func cellButtonClicked(_ sender: Any) {
        
        let selectedProduct = Product(hybProduct: self.productDetailViewModel!.product!)
        
        switch stockStatus! {
        case .outOfStock:
            productDetailViewModel?.notifyMeWhenAvailable(oncompletion: {
                self.delegate?.displayAlertForAvailabilityNotifictation()
            })
            // ATInternet
            ATInternetTaggingManager.sharedManager.sendTrackClick(clickLibelle: TaggingData.kAlerteDisponibilite , pageName: nil, chapter1: TaggingData.kProductDetails, chapter2: selectedProduct.name, level2: TaggingData.kCommerceLevel)
            break
        default:
            productDetailViewModel?.addToCart(with: self.stepperView.getQuantity(), onCompletion: {addedSuccessfully, _ in
                if addedSuccessfully {
                    self.sendWeboramaTag()
                        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "update_cart")))
                    // ATInternet
                    ATInternetTaggingManager.sharedManager.sendTrackClick(clickLibelle: TaggingData.kCtaAjoutPanier , pageName: nil, chapter1: TaggingData.kProductDetails, chapter2: selectedProduct.name, level2: TaggingData.kCommerceLevel)
                    
                    // Adjust
                    AdjustTaggingManager.sharedManager.trackEventToken(AdjustTaggingManager.kAddToCartToken)
                    
                    // Accengage
                    AccengageTaggingManager().trackAddToCart(product: selectedProduct)
                }
            })
            
            self.delegate?.addToCartButtonTapped(cell: self)
        }
    }
    
    private func sendWeboramaTag() {
        let weboramaManager = PixelWeboramaManager()
        let ccuId = UserAccount.shared.customerInfo?.displayUid?.sha256() ?? ""
        var categoryId = ""
        if productDetailViewModel?.categoryId != nil {
            categoryId = (productDetailViewModel?.categoryId)!
        } else {
            categoryId = "Farandole"
        }
        let key = weboramaManager.getKey(from:categoryId, and: .addToCart)
        weboramaManager.sendWeboramaTag(tagToSend: key, ccuIDCryptedValue: ccuId)
    }

}

extension AddToCartTableViewCell: StepperDelegate {
    func stepperTextFieldBegginEditing() {
        if delegate != nil {
            delegate?.scrollToCell(cell: self)
        }
    }

    func quantityChange(quantity: String, quantityHandler: QuantityHandler) {
    }

    func stepperTextFieldShouldReturn() {
    }
}
