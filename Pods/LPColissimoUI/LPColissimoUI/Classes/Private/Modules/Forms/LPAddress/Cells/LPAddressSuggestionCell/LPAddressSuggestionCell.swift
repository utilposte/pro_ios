//
//  LPAddressSuggestionCell.swift
//  laposte
//
//  Created by Sofien Azzouz on 20/02/2018.
//  Copyright © 2018 laposte. All rights reserved.
//


protocol LPAddressSuggestionCellDelegate: class {
    func didDeleteAddress(address: LPAddressEntity)
}

class LPAddressSuggestionCell: UITableViewCell {
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    var delegate: LPAddressSuggestionCellDelegate?
    
    var address: LPAddressEntity!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCellWithGooglePlacesDic(address: LPAddressEntity) {
        self.address = address
        addressLabel.text = address.street + " " + address.postalCode + " " + address.locality
        if (address.isLocal == "local") {
            deleteButton.isHidden = false
        }
        else {
            deleteButton.isHidden = true
        }
    }
    
    @IBAction func deleteButtonClicked() {
        self.delegate?.didDeleteAddress(address: address)
    }
    
    

}
