//
//  TitleAddressPaymentTableViewCell.swift
//  LaPostePro
//
//  Created by Matthieu Lemonnier on 03/01/2019.
//  Copyright © 2019 App Mobile. All rights reserved.
//

import UIKit

class TitleAddressPaymentTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
