//
//  OrderEntryTableViewCell.swift
//  LaPostePro
//
//  Created by Matthieu Lemonnier on 04/09/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class OrderEntryTableViewCell: UITableViewCell {

    
    @IBOutlet var entryImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var quantityLabel: UILabel!
    @IBOutlet var buyAgainView: UIView!
    @IBOutlet weak var buyAgainViewHeighConstraint: NSLayoutConstraint!
    @IBOutlet weak var reexStackView: UIStackView!
    
    var buyAgainClosure : (() -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadImage(url: String?) {
        if url == nil {
            self.entryImageView.image = R.image.ic_refresh()!
            return
        }
        ProductViewModel().loadProductImageView(url: url!, completion: { image in
            self.entryImageView.image = image
        })
    }
    
    
    @IBAction func buyAgainTapped(_ sender: Any) {
        // ATInternet
        ATInternetTaggingManager.sharedManager.sendTrackClick(clickLibelle: TaggingData.kRenouvellerAchatArticle,
                                                              pageName: nil,
                                                              chapter1: TaggingData.kMyOrders,
                                                              chapter2: TaggingData.kOrderDetails,
                                                              level2: TaggingData.kAccountLevel)
        self.buyAgainClosure?()
    }
    
}
