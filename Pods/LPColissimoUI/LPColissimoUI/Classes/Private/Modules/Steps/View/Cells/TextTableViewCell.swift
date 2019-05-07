//
//  TextTableViewCell.swift
//  LPColissimoUI
//
//  Created by Yonael Tordjman on 22/10/2018.
//

import UIKit

class TextTableViewCell: UITableViewCell {

    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func setupCell(text: String) {
        self.contentLabel.text = text
    }
}
