//
//  HomeVerticalListItemTableViewCell.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 14/05/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class HomeVerticalListItemTableViewCell: UITableViewCell {

    @IBOutlet weak var verticalListProductCountLabel: UILabel!
    @IBOutlet weak var verticalListItemImage: UIImageView!
    @IBOutlet weak var verticalListItemTitleLabel: UILabel!
    @IBOutlet weak var verticalListItemDetailLabel: UILabel!
    @IBOutlet weak var verticalListItemPriceLabel: UILabel!
    @IBOutlet weak var separatorCustomView: UIView!
    @IBOutlet weak var reexStackView: UIStackView!
    @IBOutlet weak var reexStackViewHeigConstraint: NSLayoutConstraint!
    // used to hide first separator view
    var hideSeparator = false

    //content type used to configure cell
    var listContentType: ContentType?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    func setupCell(product: Product, homeViewModel: HomeViewModel) {
        self.verticalListItemDetailLabel.textColor = UIColor.lpGrey
        if product.isReex() {
            self.reexStackView.isHidden = false
            self.reexStackViewHeigConstraint.constant = 30
            self.verticalListItemTitleLabel.text = product.getReexTitle()
            self.verticalListProductCountLabel.text = ""
            self.verticalListItemPriceLabel.attributedText = homeViewModel.getPriceText(for: .cartReex, product: product)
            if product.optionReex?.isDefinitive == true {
                self.verticalListItemDetailLabel.text = "\(product.optionReex?.duration ?? 0) mois"
            } else {
                if let startDate = product.optionReex?.startDate, let endDate = product.optionReex?.endDate {
                    self.verticalListItemDetailLabel.text = "\(startDate.reexDate()) - \(endDate.reexDate())"
                } else {
                    self.verticalListItemDetailLabel.text = "France - 20g"
                }
            }
            if product.optionReex?.isInternational == true {
                self.verticalListItemImage.image = UIImage(named: "reex-monde")
            } else {
                self.verticalListItemImage.image = UIImage(named: "reex-france")
            }
        } else {
            self.reexStackView.isHidden = true
            self.reexStackViewHeigConstraint.constant = 0
            self.verticalListItemTitleLabel.text = product.name
            if product.isColissimo() {
                var detailLine2 = "STANDARD - " + (product.optionColissimo?.weight ?? " -- ") + " kg"
                if let formatColis = product.optionColissimo?.formatColis {
                    detailLine2 = formatColis + " - " + (product.optionColissimo?.weight ?? " -- ") + " kg"
                }
                
                self.verticalListItemDetailLabel.text = (product.optionColissimo?.countryRecipient ?? "") + "\n" + detailLine2
                self.verticalListItemImage.image = R.image.icon_colissimo()
            } else {
                self.verticalListItemDetailLabel.text = product.detail
                if let productImage = product.imageUrl {
                    homeViewModel.loadProductImageView(url: productImage) { (image) in
                        self.verticalListItemImage.image = image
                    }
                }
            }
            self.verticalListProductCountLabel.text = homeViewModel.getProductCountFromCart(for: self.listContentType!, product: product)
            self.verticalListItemPriceLabel.attributedText = homeViewModel.getPriceText(for: self.listContentType!, product: product)
        }
        self.separatorCustomView.isHidden = hideSeparator
    }

}
