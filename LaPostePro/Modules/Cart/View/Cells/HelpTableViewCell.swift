//
//  HelpTableViewCell.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 18/07/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class HelpTableViewCell: UITableViewCell {

    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.containerView.layer.borderWidth = 0.3
        self.containerView.layer.cornerRadius = 5
        self.containerView.layer.borderColor = UIColor.lpDeepBlue.cgColor
            self.arrowImage.image = UIImage(named: "right-arrow")
            self.arrowImage.tintColor = .lpPurple
    }
}
