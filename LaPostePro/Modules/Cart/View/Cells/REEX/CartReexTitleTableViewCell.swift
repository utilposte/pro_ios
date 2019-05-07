//
//  CartReexTitleTableViewCell.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 28/03/2019.
//  Copyright © 2019 App Mobile. All rights reserved.
//

import UIKit

class CartReexTitleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cartReexPriceLabel: UILabel!
    @IBOutlet weak var cartReexTitleLabel: UILabel!
    @IBOutlet weak var cartReexDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func setupCell(title: String, firstDate: String, secondDate: String, price: String, duration: Int, isDefinitve: Bool) {
        self.cartReexTitleLabel.text = title
        if isDefinitve == true {
            self.cartReexDateLabel.text = "Durée: \(duration) mois\nDébut: \(firstDate.reexDate()) - Fin: \(secondDate.reexDate())"
        } else {
            self.cartReexDateLabel.text = "Début: \(firstDate.reexDate()) - Fin: \(secondDate.reexDate())"
        }
        self.cartReexPriceLabel.text = price
    }
}
