//
//  OrderDetailImageTableViewCell.swift
//  LaPostePro
//
//  Created by Matthieu Lemonnier on 03/09/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class OrderDetailImageTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var widthImgLayoutConstraint: NSLayoutConstraint!
    
    func delivery(mode: Bool) {
        if mode {
            widthImgLayoutConstraint.constant = 90
        }
        else {
            widthImgLayoutConstraint.constant = 60
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
