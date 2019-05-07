//
//  SupportTableViewCell.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 20/06/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class SupportTableViewCell: UITableViewCell {

    @IBOutlet weak var customView: UIView!
    @IBOutlet weak var supportImage: UIImageView!
    @IBOutlet weak var supportLabel: UILabel!
    @IBOutlet weak var supportChevron: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    internal func setupSupportCell() {
        let color = UIColor(red: 225, green: 227, blue: 229)
        self.customView.addBorder(withColor: color.cgColor, andThickness: 1, andCornerRaduis: 5)
        self.supportLabel.text = "Besoin d'aide ?"
        self.supportLabel.font = UIFont.boldSystemFont(ofSize: 15)
        self.supportLabel.textColor = UIColor(red: 5, green: 15, blue: 54)
        self.supportImage.image = R.image.help_icon()
        self.supportChevron.image = R.image.ic_cat_link()
        self.supportChevron.tintImageColor(color: .lpPurple)
    }

}
