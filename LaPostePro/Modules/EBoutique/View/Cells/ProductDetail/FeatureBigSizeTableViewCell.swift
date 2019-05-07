//
//  FeatureBigSizeTableViewCell.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 14/06/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class FeatureBigSizeTableViewCell: UITableViewCell {

    @IBOutlet weak var validityZoneLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupCell(feature: ProductFeature) {
        validityZoneLabel.text = feature.value?.htmlToString
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
