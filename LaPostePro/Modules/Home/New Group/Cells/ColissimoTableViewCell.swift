//
//  ColissimoTableViewCell.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 27/12/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class ColissimoTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var colissimoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func setupCell() {
        self.colissimoImageView.image = UIImage.init(named: "colissimo-entry")
        self.containerView.layer.cornerRadius = 5
        self.containerView.layer.borderColor = UIColor.darkGray.cgColor
        self.containerView.layer.borderWidth = 1
        self.colissimoImageView.clipsToBounds = true
    }

}
