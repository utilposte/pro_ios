//
//  DeliveryTypeTableViewCell.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 31/07/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class DeliveryTypeTableViewCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var typeImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
        self.containerView.layer.cornerRadius = 5
        self.containerView.layer.borderColor = UIColor.lpGrayShadow.cgColor
        self.containerView.layer.borderWidth = 1
    }
    
    internal func setupCell(type: String) {
        if type == "colis"  || type == "colissimo"{
            self.typeImageView.image = UIImage(named: "colissimo")
        } else if type == "chronopost" {
            self.typeImageView.image = UIImage(named: "chronopost")
        } else {
            self.typeImageView.image = UIImage(named: "letters")
        }
    }
}
