//
//  HomeLocaliserTableViewCell.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 11/05/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class HomeLocaliserTableViewCell: UITableViewCell {

    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.containerView.layer.cornerRadius = 5
        self.containerView.layer.borderColor = UIColor.lpGrayShadow.cgColor
        self.containerView.layer.borderWidth = 1
        self.containerView.clipsToBounds = true
        self.arrowImageView.image = R.image.rightArrow()
        self.arrowImageView.tintColor = .lpPurple
    }
}
