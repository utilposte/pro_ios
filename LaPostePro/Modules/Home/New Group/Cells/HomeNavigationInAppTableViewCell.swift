//
//  HomeNavigationInAppTableViewCell.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 11/05/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class HomeNavigationInAppTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var moduleImageView: UIImageView!
    @IBOutlet weak var moduleNameLabel: UILabel!
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var moduleImageBackgroundView: UIView!
    // MARK: parameters
    var deepLink: String?

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    func setupCell (module: Module) {
        self.moduleNameLabel.text = module.moduleName
        self.moduleImageView.image = module.moduleImage
        self.containerView.addRadius(value: 5, color: UIColor.clear.cgColor, width: 1)
        self.moduleImageBackgroundView.roundCorners([.topLeft, .bottomLeft], radius: 5)
//        self.rightImageView.image = R.image.rightArrow()
//        self.rightImageView.tintColor = .lpPurple
        self.moduleImageBackgroundView.backgroundColor = module.moduleImageBackgroundColor

        containerView.layer.applyShadow(
            color: .lpGrayShadow,
            alpha: 1,
            x: 0,
            y: 2,
            blur: 20,
            spread: 0)

        switch module.moduleRedirectionType! {
        case .redirectionToCategory:
            self.moduleImageView.contentMode = .scaleAspectFit
            self.backgroundColor = UIColor.white
            return
        default:
            self.moduleImageView.contentMode = .center
            self.backgroundColor = .lpBackgroundGrey
            return
        }
    }

    override func prepareForReuse() {
        self.moduleImageBackgroundView.backgroundColor = .clear
    }

}
