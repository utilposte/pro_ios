//
//  ColissimoHomeAdvantageHeaderCell.swift
//  LPColissimoUI
//
//  Created by Issam DAHECH on 24/10/2018.
//

import UIKit

class ColissimoHomeAdvantageHeaderCell: UITableViewCell {

    @IBOutlet weak var advantagesTitleLabel: UILabel!
    @IBOutlet weak var colissimoImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        advantagesTitleLabel.text = LocalizedColissimoUI(key: "k_home_advantage_header")
        self.colissimoImage.image = UIImage.loadImage(name: "ic_colissimo_black.png")
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
