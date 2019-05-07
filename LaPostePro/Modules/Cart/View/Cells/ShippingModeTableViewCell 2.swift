//
//  ShippingModeTableViewCell.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 18/07/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class ShippingModeTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var shippingType: UILabel!
    @IBOutlet weak var shippingAmount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.containerView.layer.cornerRadius = 5
        self.containerView.layer.borderColor = UIColor.lpDeepBlue.cgColor
        self.containerView.layer.borderWidth = 0.3
    }
    
    func setupShippingModeCell(type: String, amount: String) {
        self.shippingType.text = type
        if let amountInt = Int(amount), amountInt >= 0 {
            let amountString = amount.replacingOccurrences(of: ".", with: ",")
            self.shippingAmount.text = "\(amountString) €"
        } else {
            self.shippingAmount.text = "Offert"
        }
    }

}
