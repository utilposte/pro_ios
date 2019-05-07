//
//  OrderAddressTableViewCell.swift
//  LaPostePro
//
//  Created by Matthieu Lemonnier on 03/09/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class OrderAddressTableViewCell: UITableViewCell {

    
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var line1Label: UILabel!
    @IBOutlet var line2Label: UILabel!
    @IBOutlet var countryLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
