//
//  MascadiaAddressTableViewCell.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 10/10/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class MascadiaAddressTableViewCell: UITableViewCell {
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressCheckedImageview: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    func setupCell(with address: AddressMascadia, isSelected: Bool) {
        addressCheckedImageview.cornerRadius = addressCheckedImageview.frame.height / 2
        if (isSelected) {
            addressLabel.textColor = .lpPurple
            addressCheckedImageview.layer.borderWidth = 1
            addressCheckedImageview.layer.borderColor = UIColor.lpPurple.cgColor
            addressCheckedImageview.image = R.image.smallCheck()
        } else {
            addressLabel.textColor = .lpGrey
            addressCheckedImageview.layer.borderWidth = 1
            addressCheckedImageview.layer.borderColor = UIColor.lpGrey.cgColor
            addressCheckedImageview.image = UIImage()
        }
        addressLabel.text = String(format: "%@\n%@ %@", address.street ?? "", address.postalCode ?? "", address.locality ?? "")
    }

}
