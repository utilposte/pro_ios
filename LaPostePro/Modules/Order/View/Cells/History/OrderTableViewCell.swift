//
//  OrderTableViewCell.swift
//  LaPostePro
//
//  Created by Matthieu Lemonnier on 28/08/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class OrderTableViewCell: UITableViewCell {

    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var refLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        let details = NSMutableAttributedString()
        details.custom("Plus de détails ", font: self.detailLabel.font, color: .black)
        
        details.image(R.image.ic_next_month()!, font: self.detailLabel.font)
        self.detailLabel.attributedText = details
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
