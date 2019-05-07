//
//  ProductCartColissimoTableViewCell.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 25/03/2019.
//  Copyright © 2019 App Mobile. All rights reserved.
//

import UIKit

protocol ProductCartColissimoTableViewCellDelegate: class {
    func didDeletedColissimo(index: Int)
    func didPushedColissimoDetails(product: Product)
    func didPushedReexDetails(product: Product)
}

class ProductCartColissimoTableViewCell: UITableViewCell {

    var product: Product?
    weak var delegate: ProductCartColissimoTableViewCellDelegate?
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var productDescLabel: UILabel!
    @IBOutlet weak var additionalInfoLabel: UILabel!
    @IBOutlet weak var unitPriceHTLabel: UILabel!
    @IBOutlet weak var heightCellConstraint: NSLayoutConstraint!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    func setupCell(product: Product) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ProductCartColissimoTableViewCell.displayColissimoDetail))
        self.mainView.addGestureRecognizer(tapGesture)
        self.product = product
        self.productTitleLabel.text = product.name
        self.productImageView.image = R.image.ic_colissimo()
        self.unitPriceHTLabel.text = product.optionColissimo?.totalNetPriceColis
        self.additionalInfoLabel.text = product.optionColissimo?.countryRecipient
        if let formatColis = product.optionColissimo?.formatColis {
            self.productDescLabel.text = formatColis + " - " + (product.optionColissimo?.weight ?? " -- ") + " kg"
        } else {
            self.productDescLabel.text = "STANDARD - " + (product.optionColissimo?.weight ?? " -- ") + " kg"
        }
        self.layoutIfNeeded()
    }
    
    func setupCellForReex(product: Product) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ProductCartColissimoTableViewCell.displayReexDetail))
        self.mainView.addGestureRecognizer(tapGesture)
        self.product = product
        self.productTitleLabel.text = product.getReexTitle()
        self.productDescLabel.text = ""
        if self.product?.optionReex?.isInternational == true {
            self.productImageView.image = UIImage(named: "reex-monde")
        } else {
            self.productImageView.image = UIImage(named: "reex-france")
        }
        
        self.unitPriceHTLabel.text = product.optionReex?.price
        
        if self.product?.optionReex?.isDefinitive == true {
            self.additionalInfoLabel.text = "\(product.optionReex?.duration ?? 0) mois"
        } else {
            if let startDate = product.optionReex?.startDate, let endDate = product.optionReex?.endDate {
                self.additionalInfoLabel.text = "\(startDate.reexDate()) - \(endDate.reexDate())"
            }
        }
        self.layoutIfNeeded()
    }
    
    @IBAction func deleteProduct(_ sender: Any) {
        if let product = self.product, let entryNumber = product.entryNumber {
            self.delegate?.didDeletedColissimo(index: entryNumber)            
        }
    }
    
    @IBAction func moreDetails(_ sender: Any) {
        if let product = self.product, let _ = product.entryNumber, !product.isReex() {
            self.delegate?.didPushedColissimoDetails(product: product)
        }
        
        if let product = self.product, product.isReex() {
            self.delegate?.didPushedReexDetails(product: product)
        }
    }
    
    @objc func displayColissimoDetail() {
        if let product = self.product, let _ = product.entryNumber {
            self.delegate?.didPushedColissimoDetails(product: product)
        }
    }
    
    @objc func displayReexDetail() {
        if let product = self.product, product.isReex() {
            self.delegate?.didPushedReexDetails(product: product)
        }
    }
}
