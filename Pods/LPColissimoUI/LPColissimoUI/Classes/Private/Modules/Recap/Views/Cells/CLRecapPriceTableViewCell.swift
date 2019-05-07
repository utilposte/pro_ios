//
//  CLRecapPriceTableViewCell.swift
//  LPColissimoUI
//
//  Created by Yonael Tordjman on 14/01/2019.
//

import UIKit

class CLRecapPriceTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func setupCell(price: Double) {
        // Format price
        self.priceLabel.text = "\(String(format: "%.2f", price)) €"
        self.priceLabel.text = self.priceLabel.text?.replacingOccurrences(of: ".", with: ",")
        
        self.descriptionLabel.text = "Le service Colissimo en ligne n'est pas soumis à la TVA"
    }
}
