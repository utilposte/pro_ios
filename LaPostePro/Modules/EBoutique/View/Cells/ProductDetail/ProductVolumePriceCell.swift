//
//  ProductVolumePriceCell.swift
//  LaPostePro
//
//  Created by Issam DAHECH on 14/12/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class ProductVolumePriceCell: UITableViewCell {

    @IBOutlet weak var volumeContainerView: UIView!
    @IBOutlet weak var volumeContainerViewConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCellWith(_ volumePrices: [VolumePrice]) {
        let height = volumePrices.count*50
        let volumeView = UIView.init(frame: CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.width-40), height: height))
        var i = 0
        for volumePrice in volumePrices {
            if let view = ProductVolumeView.instanceFromNib() as?  ProductVolumeView {
                view.setUpView(volumePrice: volumePrice, y: i*50)
                i += 1
                volumeView.addSubview(view)
            }
        }
        volumeContainerView.addSubview(volumeView)
        volumeContainerViewConstraint.constant = CGFloat(height)
    }
    
}
