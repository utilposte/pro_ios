//
//  InfoProfileTableViewCell.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 14/08/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class InfoProfileTableViewCell: UITableViewCell {
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    internal func setupCell(info: String, value: String) {
        self.infoLabel.text = info
        self.valueLabel.text = value
    }
}
