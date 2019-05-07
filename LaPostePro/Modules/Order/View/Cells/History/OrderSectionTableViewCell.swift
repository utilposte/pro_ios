//
//  OrderSectionTableViewCell.swift
//  LaPostePro
//
//  Created by Matthieu Lemonnier on 30/08/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class OrderSectionTableViewCell: UITableViewCell {

    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
