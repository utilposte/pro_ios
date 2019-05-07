//
//  CartReexContractTableViewCell.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 28/03/2019.
//  Copyright © 2019 App Mobile. All rights reserved.
//

import UIKit

class CartReexContractTableViewCell: UITableViewCell {
    
    @IBOutlet weak var reexCartContractTitleLabel: UILabel!
    @IBOutlet weak var reexCartActivationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func setupCell(title: String, contract: String) {
        self.reexCartContractTitleLabel.text = title
        self.reexCartActivationLabel.text = contract
        self.reexCartActivationLabel.textColor = UIColor.lpGrey
    }

}
