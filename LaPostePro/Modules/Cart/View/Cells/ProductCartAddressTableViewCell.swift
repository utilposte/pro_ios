//
//  ProductCartAddressTableViewCell.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 26/03/2019.
//  Copyright © 2019 App Mobile. All rights reserved.
//

import UIKit
import LPSharedMCM

class ProductCartAddressTableViewCell: UITableViewCell {

    @IBOutlet weak var productCartAddressLabel: UILabel!
    @IBOutlet weak var productCartAddressTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func setupCell(title: String, address: HYBAddress?) {
        self.productCartAddressTitleLabel.text = title
        
        var userAddress = ""
        if let title = address?.title, let firstName = address?.firstName, let lastName = address?.lastName {
            userAddress += "\(title) \(firstName) \(lastName)\n"
        }
        
        if let company = address?.companyName {
            userAddress += "\(company)\n"
        }
        
        if let line1 = address?.line1 {
            userAddress += "\(line1)\n"
        }
        
        if let postalCode = address?.postalCode, let town = address?.town {
            userAddress += "\(postalCode) \(town) \n"
        }
        
        if let country = address?.country.name {
            userAddress += "\(country)"
        }
        
        self.productCartAddressLabel.text = userAddress
    }
    
    func setupCellReex(title: String, address: ReexAddress?) {
        self.productCartAddressTitleLabel.text = title
        
        var userAddress = ""
        
        if let street = address?.street {
            userAddress += "\(street)\n"
        }
        
        if let postalCode = address?.postalCode, let town = address?.town {
            userAddress += "\(postalCode), \(town) \n"
        }
        
        if let country = address?.country {
            userAddress += "\(country)"
        }
        
        self.productCartAddressLabel.text = userAddress
    }
}
