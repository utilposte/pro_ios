//
//  FeatureSmallSizeTableViewCell.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 14/06/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class FeatureSmallSizeTableViewCell: UITableViewCell {

    @IBOutlet weak var featureName: UILabel!
    @IBOutlet weak var featureValue: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setupCell(feature: ProductFeature) {
        featureName.text = feature.name
        featureValue.text = feature.value
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
