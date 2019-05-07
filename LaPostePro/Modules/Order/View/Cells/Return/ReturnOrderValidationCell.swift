//
//  ReturnOrderValidationCell.swift
//  LaPostePro
//
//  Created by Issam DAHECH on 03/12/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class ReturnOrderValidationCell: UITableViewCell {

    @IBOutlet weak var validateButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setUpCell(canValidate : Bool) {
        if canValidate {
            validateButton.setActionPrimary()
            validateButton.isEnabled = true

        }
        else {
            validateButton.setActionDisabled()
            validateButton.isEnabled = false
        }
    }
}
