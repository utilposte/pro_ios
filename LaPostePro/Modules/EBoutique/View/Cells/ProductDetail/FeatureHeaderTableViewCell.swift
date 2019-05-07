//
//  FeatureHeaderTableViewCell.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 14/06/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class FeatureHeaderTableViewCell: UITableViewCell {

    weak var delegate: ProductDetailDelegate?
    
    var featureSize: FeatureSize = .small
    @IBOutlet weak var changeFeaturesListButton: UIButton!

    func setupCell(with featureSize: FeatureSize) {
        self.featureSize = featureSize
        switch featureSize {
        case .small:
            changeFeaturesListButton.setTitle("Plus de détails", for: .normal)
        case .big:
            changeFeaturesListButton.setTitle("Moins de détails", for: .normal)
        }
    }
    @IBAction func changeFeatureListButtonClicked(_ sender: Any) {
        if delegate != nil {
            if (featureSize == .small) {
                featureSize = .big
            } else {
                featureSize = .small
            }
            setupCell(with: featureSize)
            
            delegate?.changeFeaturesListSize()
        }
    }

}
