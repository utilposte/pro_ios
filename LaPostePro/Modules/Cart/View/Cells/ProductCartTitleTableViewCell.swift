//
//  ProductCartTitleTableViewCell.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 25/03/2019.
//  Copyright © 2019 App Mobile. All rights reserved.
//

import UIKit

class ProductCartTitleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productCartTitleLabel: UILabel!
    @IBOutlet weak var productCartPriceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(title: String, price: String) {
        self.productCartTitleLabel.text = title
        self.productCartPriceLabel.text = price
    }
    
}
