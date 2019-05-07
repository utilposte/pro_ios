//
//  HomeAdviseTableViewCell.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 08/06/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class HomeAdviseTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.addBorder(withColor: UIColor.clear.cgColor, andThickness: 1, andCornerRaduis: 5)
        containerView.layer.applyShadow(color: .lpBackgroundGrey, alpha: 1, x: 0, y: 2, blur: 20, spread: 10)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
