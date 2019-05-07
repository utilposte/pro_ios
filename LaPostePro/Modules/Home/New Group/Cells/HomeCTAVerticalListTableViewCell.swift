//
//  HomeCTAVerticalListTableViewCell.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 14/05/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class HomeCTAVerticalListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var verticalListMoreDetailLabel: UILabel!
    @IBOutlet weak var buttonContainerView: UIView!
    @IBOutlet weak var buttonTitleLabel: UILabel!
    @IBOutlet weak var buttonIconImageView: UIImageView!
    @IBOutlet weak var labelHeightConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    func setupCell(module: Module, homeViewModel: HomeViewModel) {

        buttonTitleLabel.text = module.actionDescription!
        buttonContainerView.layer.cornerRadius = 5
        buttonContainerView.clipsToBounds = true
        buttonIconImageView.image = homeViewModel.getVerticalListIcon(for: module.contentType!)
        buttonIconImageView.tintImageColor(color: UIColor.white)
        
        if module.items!.count > 3 {
            if(module.contentType == .lastBuyList) {
                verticalListMoreDetailLabel.attributedText = HomeViewModel().getHomeCTAverticalListDetailText(productNumber: (module.items!.count - 3), specificText: "")
                verticalListMoreDetailLabel.isHidden = false
            } else if module.contentType == .cartList{
                verticalListMoreDetailLabel.attributedText = HomeViewModel().getHomeCTAverticalListDetailText(productNumber: homeViewModel.getCartRemainingProductsQuantity(for: module.items!), specificText: Constants.textForHomeCartList)
                verticalListMoreDetailLabel.isHidden = false
            } else if module.contentType == .favoritesList{
                                verticalListMoreDetailLabel.attributedText = HomeViewModel().getHomeCTAverticalListDetailText(productNumber: (module.items!.count - 3), specificText: Constants.textForHomeFavoriteList)
                verticalListMoreDetailLabel.isHidden = false
            } else {
                verticalListMoreDetailLabel.isHidden = true
                labelHeightConstraint.constant = 0
                layoutIfNeeded()
            }
        } else {
            verticalListMoreDetailLabel.isHidden = true
            labelHeightConstraint.constant = 0
            layoutIfNeeded()
        }
    }

    override func prepareForReuse() {
        verticalListMoreDetailLabel.text = ""
//        verticalListButton = nil
    }
}
