//
//  PriceProductTableViewCell.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 07/05/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class PriceProductTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var productNumberLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    internal func configurePriceProductCell(itemNumber: Int, TTCPrice: String) {
        self.productNumberLabel.text = itemNumber > 1 ? "\(itemNumber) produits" : "\(itemNumber) produit"
        self.productNumberLabel.font = UIFont.systemFont(ofSize: 14)
        self.productNumberLabel.textColor = .lpDeepBlue
        if itemNumber == 0 {
            self.priceLabel.isHidden = true
        } else {
            self.priceLabel.isHidden = false
            self.priceLabel.attributedText = NSMutableAttributedString.init()
                .custom("Total TTC:  ", font: UIFont.systemFont(ofSize: 14), color: .lpGrey)
                .custom(TTCPrice, font: UIFont.boldSystemFont(ofSize: 17), color: .lpPurple)
        }
    }

}
