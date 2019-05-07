//
//  AlertFollowDetailTableViewCell.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 08/08/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class AlertFollowDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var sentenceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.sentenceLabel.attributedText = NSMutableAttributedString()
        .custom("Dans un délai de ", font: UIFont.systemFont(ofSize: 15), color: .lpDeepBlue)
        .custom("15 jours ", font: UIFont.boldSystemFont(ofSize: 15), color: .lpPurple)
        .custom("votre suivi sera supprimé", font: UIFont.systemFont(ofSize: 15), color: .lpDeepBlue)
        
    }
}
