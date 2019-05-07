//
//  DeliveryModeTableViewCell.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 31/07/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class DeliveryModeTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var deliveryModeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.containerView.layer.cornerRadius = 5
        self.containerView.layer.borderColor = UIColor.lpGrayShadow.cgColor
        self.containerView.layer.borderWidth = 1
    }
    
    internal func setupCell(deliveryMode: String) {
        self.deliveryModeLabel.text = deliveryMode
    }
}
