//
//  FormalitiesInfoTableViewCell.swift
//  LPColissimoUI
//
//  Created by Yonael Tordjman on 30/11/2018.
//

import UIKit

class FormalitiesInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var infoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func setupCell(title: NSMutableAttributedString) {
        self.infoLabel.attributedText = title        
    }
    
}
