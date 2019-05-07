//
//  AddressBillingTableViewCell.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 18/07/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

protocol ChangeBillingAddressDelegate {
    func sameBillingAddressAsDeliverySwitchChangeValue(useTheSame: Bool)
}

class AddressBillingTableViewCell: UITableViewCell {

    @IBOutlet weak var useTheSameAddress: UISwitch!
    var delegate: ChangeBillingAddressDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func setSwitch(isOn: Bool, isEnabled: Bool) {
        useTheSameAddress.isOn = isOn
        self.useTheSameAddress.isEnabled = isEnabled
    }

    @IBAction func sameAsDelivrryAddressSwitchValueChange(_ sender: UISwitch) {
        delegate?.sameBillingAddressAsDeliverySwitchChangeValue(useTheSame: sender.isOn)
    }
}
