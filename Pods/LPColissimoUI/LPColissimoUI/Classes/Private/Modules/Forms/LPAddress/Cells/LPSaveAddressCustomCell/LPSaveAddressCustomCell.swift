//
//  LPSaveAddressCustomCell.swift
//  laposte
//
//  Created by Lassad Tiss on 20/03/2018.
//  Copyright © 2018 laposte. All rights reserved.
//

import UIKit

@objc protocol LPSaveAddressCellDelegate: class {
    @objc func didSelectSaveAddress(isSelected: Bool)
}

class LPSaveAddressCustomCell: LPBaseCustomCell {

    @IBOutlet weak var checkBoxButton: UIButton!
    var isSaveAddressSelected = false
    var delegate: LPSaveAddressCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func checkBoxButtonClicked(_ sender: UIButton) {
        var selectedCheckboxImage:UIImage?
        if !isSaveAddressSelected {
            selectedCheckboxImage = UIImage(named: "MCM_checkBox_blue_with_border")
            isSaveAddressSelected = true
        } else {
            selectedCheckboxImage = UIImage(named: "connection_CheckBox")
            isSaveAddressSelected = false
        }
        sender.setImage(selectedCheckboxImage, for: .normal)
        delegate?.didSelectSaveAddress(isSelected: isSaveAddressSelected)
    }
    
}
