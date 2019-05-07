//
//  ShippingTableViewCell.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 07/05/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit
import LPSharedMCM

class ShippingTableViewCell: UITableViewCell {

    @IBOutlet weak var shippingInfoLabel: UILabel!
    @IBOutlet weak var shippingIcon: UIImageView!
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor(red: 255, green: 223, blue: 228)
        self.selectionStyle = .none
        self.shippingInfoLabel.textColor = UIColor(red: 5, green: 14, blue: 54)
        self.shippingInfoLabel.font = UIFont.systemFont(ofSize: 15)
        self.shippingIcon.image = R.image.free_shipping()
    }

    internal func configureShippingCell(amount: Float) {
        if amount > 0 {
            self.leftConstraint.constant = 0
            self.shippingInfoLabel.textAlignment = .center
            var amountTmp = String(format:"%.2f", amount).replacingOccurrences(of: ".", with: ",")
            amountTmp = amountTmp.replacingOccurrences(of: ".", with: ",")
            let amountString = amountTmp
            self.shippingInfoLabel.attributedText = NSMutableAttributedString.init()
                .custom("Plus que ", font: UIFont.systemFont(ofSize: 15), color: .lpDeepBlue)
                .custom("\(amountString) € ", font: UIFont.boldSystemFont(ofSize: 15), color: .lpPurple)
                .custom("de produits physiques à ajouter à votre panier pour bénéficier de ", font: UIFont.systemFont(ofSize: 15), color: .lpDeepBlue)
                .custom("la gratuité des frais de port", font: UIFont.boldSystemFont(ofSize: 15), color: .lpDeepBlue)
            self.shippingIcon.isHidden = true
        } else {
            self.leftConstraint.constant = 80
            self.shippingInfoLabel.textAlignment = .left
            self.shippingInfoLabel.text = "Les frais de port sont offerts"
            self.shippingIcon.isHidden = false
        }
    }

}
