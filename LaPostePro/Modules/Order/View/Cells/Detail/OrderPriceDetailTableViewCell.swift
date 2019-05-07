//
//  OrderPriceDetailTableViewCell.swift
//  LaPostePro
//
//  Created by Matthieu Lemonnier on 04/09/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class OrderPriceDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var priceHTLabel: UILabel!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var deliveryCostLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    var closureOrderAgain : (() -> Void)? = nil

    @IBAction func orderAgainTapped(_ sender: Any) {
        // ATInternet
        ATInternetTaggingManager.sharedManager.sendTrackClick(clickLibelle: TaggingData.kCommandeIdentique,
                                                              pageName: nil,
                                                              chapter1: TaggingData.kMyOrders,
                                                              chapter2: TaggingData.kOrderDetails,
                                                              level2: TaggingData.kAccountLevel)
        
        self.closureOrderAgain?()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
