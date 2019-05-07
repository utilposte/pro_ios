//
//  AddAddressTableViewCell.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 18/07/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class AddAddressTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.containerView.layer.cornerRadius = 5
    }

}
