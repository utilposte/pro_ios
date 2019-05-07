//
//  TitleFollowStepTableViewCell.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 08/08/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class TitleFollowStepTableViewCell: UITableViewCell {

    @IBOutlet weak var sentenceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    internal func setupCell(delivered: Bool) {
        if delivered {
            self.sentenceLabel.text = "Livré"
        } else {
            self.sentenceLabel.text = "En cours de distribution"
        }
    }

}
