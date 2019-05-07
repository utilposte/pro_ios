//
//  SixthPriceTableViewCell.swift
//  LPColissimoUI
//
//  Created by Yonael Tordjman on 27/11/2018.
//

import UIKit

class SixthPriceTableViewCell: UITableViewCell {

    
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    func setupCell(title: NSMutableAttributedString) {
        self.priceLabel.attributedText = title
    }
    
}
