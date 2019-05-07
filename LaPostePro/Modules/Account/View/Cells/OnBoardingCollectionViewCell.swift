//
//  OnBoardingCollectionViewCell.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 02/07/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class OnBoardingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var descriptionImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    func confugure(with index: IndexPath) {
        self.descriptionImageView.backgroundColor = .lpPink
        self.descriptionImageView.contentMode = .center
        switch index.row {
        case 0:
            descriptionLabel.text = "Accédez à l'ensemble  des produits de la boutique pro"
            self.descriptionImageView.image = R.image.img_onboarding_1()
        case 1:
            descriptionLabel.text = "Retrouvez vos factures et commandes dans votre compte"
            self.descriptionImageView.image = R.image.img_onboarding_2()
        case 2:
            descriptionLabel.text = "Suivez vos colis en cours et localisez le bureau le plus proche"
            self.descriptionImageView.image = R.image.img_onboarding_3()
        default:
            return
        }
    }
}
