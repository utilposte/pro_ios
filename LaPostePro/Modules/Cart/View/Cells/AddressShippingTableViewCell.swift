//
//  AddressShippingTableViewCell.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 18/07/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

protocol OrderAddressesDelegate {
    func edit(address: DeliveryAddress)
}

class AddressShippingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var edgeView: UIView!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var streetAddress: UILabel!
    @IBOutlet weak var postalCode: UILabel!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var editAddressLabel: UILabel!
    
    var address: DeliveryAddress?
    var delegate: OrderAddressesDelegate?
    var isBillingAddress = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    internal func setupAddressCell(address: DeliveryAddress) {
        self.address = address
        self.companyName.text = self.address?.companyName ?? ""
        self.nameLabel.text = "\(self.address?.title ?? "") \(self.address?.firstName ?? "") \(self.address?.lastName ?? "")"
        self.streetAddress.text = self.address?.line1 ?? ""
        self.postalCode.text = getLocality()
        self.country.text = self.address?.countryName
        self.checkImage.isHidden = !address.shippingAddress
        self.selectionStyle = .none
        self.edgeView.layer.borderColor = UIColor.lpPurple.cgColor
        self.edgeView.layer.cornerRadius = 5
        self.edgeView.layer.borderWidth = 1
        
        if isBillingAddress {
            editAddressLabel.isUserInteractionEnabled = true
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(editAddress))
            editAddressLabel.addGestureRecognizer(tapGestureRecognizer)
        }
    }
    
    @objc func editAddress() {
        delegate?.edit(address: self.address!)
    }
    
    private func getLocality() -> String {
        return "\(address?.town ?? "") \(address?.postalCode ?? "")"
    }
    
}
