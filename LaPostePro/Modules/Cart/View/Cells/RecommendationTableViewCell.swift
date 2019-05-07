//
//  RecommendationTableViewCell.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 07/05/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class RecommendationTableViewCell: UITableViewCell {

    // MARK: IBOutlet
    @IBOutlet weak var titleSectionLabel: UILabel!
    @IBOutlet weak var recentlyBuyLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var recommendationImageView: UIImageView!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var productDescLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

//    internal func configureRecommendationCell() {
//        self.titleSectionLabel.text = "Nous vous recommandons"
//        self.titleSectionLabel.font = UIFont.boldSystemFont(ofSize: 16)
//        self.recentlyBuyLabel.attributedText = NSMutableAttributedString.init()
//            .custom("Vous avez acheté recemment ", font: UIFont.systemFont(ofSize: 14), color: .black)
//            .custom("Carnet de 12 timbres Marianne", font: UIFont.boldSystemFont(ofSize: 14), color: .black)
//
//        self.productTitleLabel.text = "Prêt-à-Poster - Lettre suivie - 50g - à fenêtre - Lot de 100"
//        self.productDescLabel.text = "50g"
//        self.recommendationImageView.backgroundColor = .blue
//    }
    
    func setupCell(with product: Product) {
        titleSectionLabel.text = "Nous vous recommandons"
        productTitleLabel.text = product.name
        recentlyBuyLabel.text = product.detail
        productDescLabel.attributedText = ProductViewModel().getPriceText(for: .favoritesList, product: product)
        ProductViewModel().loadProductImageView(url: product.imageUrl!) { (productImage) in
            self.recommendationImageView.image = productImage
        }
        
    }

}
