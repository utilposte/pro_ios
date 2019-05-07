//
//  ColissimoHomeAdvantagesCell.swift
//  LPColissimoUI
//
//  Created by Issam DAHECH on 24/10/2018.
//

import UIKit

class ColissimoHomeAdvantagesCell: UITableViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var advantagesTitleLabel: UILabel!
    @IBOutlet weak var advantagesDescriptionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(avantage : HomeAdvantageViewModel) {
        advantagesTitleLabel.text = avantage.title
        advantagesDescriptionLabel.text = avantage.description
        if let image = avantage.icon {
            iconImageView.image = image
        }
    }
    
}
