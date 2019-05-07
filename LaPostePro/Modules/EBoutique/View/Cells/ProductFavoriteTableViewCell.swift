//
//  ProductFavoriteTableViewCell.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 01/03/2019.
//  Copyright © 2019 App Mobile. All rights reserved.
//

import UIKit

class ProductFavoriteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var favoriteLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell() {        
        let myString = NSMutableAttributedString().image(UIImage(named: "ic_small_favorite")!, font: self.favoriteLabel.font)
        myString.append(NSAttributedString.init(string: " Produit présent dans vos favoris"))
        
        self.favoriteLabel.attributedText = myString
    }
    
}
