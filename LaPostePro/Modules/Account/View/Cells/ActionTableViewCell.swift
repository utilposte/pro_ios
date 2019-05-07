//
//  ActionTableViewCell.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 14/08/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class ActionTableViewCell: UITableViewCell {

    @IBOutlet weak var actionImage: UIImageView!
    @IBOutlet weak var actionLabel: UILabel!
    @IBOutlet weak var actionView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
        self.actionView.layer.cornerRadius = 5
        self.actionView.layer.borderColor = UIColor.lpGrayShadow.cgColor
        self.actionView.layer.borderWidth = 1
    }
    
    internal func setupCell(image: UIImage, title: String) {
        self.actionLabel.text = title
        self.actionImage.image = image
    }

}
