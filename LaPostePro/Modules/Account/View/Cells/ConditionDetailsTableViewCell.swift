//
//  ConditionDetailsTableViewCell.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 17/08/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class ConditionDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var detailsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    internal func setupCell(expanded: Bool) {
        if expanded {
            self.detailsLabel.text = "Moins de détails"
        } else {
            self.detailsLabel.text = "Plus de détails"
        }
    }

}
