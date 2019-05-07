//
//  AccountHomeTableViewCell.swift
//  LaPostePro
//
//  Created by Lassad Tiss on 05/07/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

protocol AccountHomePageCellsDelegate {
    func needHelpTapped()
}

enum AccountCellType {
    case order
    case needHelp
    case contactList
    case favorites
}

class AccountHomeTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var detailHeightConstraint: NSLayoutConstraint!

    var delegate: AccountHomePageCellsDelegate?
//    var gesture = UITapGestureRecognizer(target: self, action: #selector(AccountHomeTableViewCell.cellTapped))
    
    @IBOutlet weak var contaierView: UIView!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contaierView.layer.applyShadow(color: .lpGrayShadow, alpha: 1, x: 0, y: 2, blur: 20, spread: 0)
        //detailsView.roundCorners([.bottomLeft, .bottomRight], radius: 5)
    }
    
    func setupAsDetailedCell(){
        heightConstraint.constant = 120.0
        detailHeightConstraint.constant = 60.0
        layoutIfNeeded()
    }

    func setupAsTitledCell(){
        heightConstraint.constant = 60.0
        detailHeightConstraint.constant = 0
        layoutIfNeeded()
        if (titleLabel.text?.elementsEqual("Besoin d'aide ?"))! {
            quantityLabel.text = ""
//            self.addGestureRecognizer(gesture)
        }
    }
    
//    @objc private func cellTapped() {
//        // ATInternet
//        ATInternetTaggingManager.sharedManager.sendTrackClick(clickLibelle: TaggingData.kBesoinAide,
//                                                              pageName: nil,
//                                                              chapter1: nil,
//                                                              chapter2: nil,
//                                                              level2: TaggingData.kAccountLevel)
//
//        delegate?.needHelpTapped()
//    }
}
