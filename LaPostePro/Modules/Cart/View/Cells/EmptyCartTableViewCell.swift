//
//  EmptyCartTableViewCell.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 07/05/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class EmptyCartTableViewCell: UITableViewCell {

    @IBOutlet weak var emptyCartTitleLabel: UILabel!
    @IBOutlet weak var emptyCartDescLabel: UILabel!
    @IBOutlet weak var emptyCartImageView: UIImageView!
    @IBOutlet weak var emptyCartSentence: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.emptyCartTitleLabel.font = UIFont.italicSystemFont(ofSize: 15)
        self.emptyCartTitleLabel.textColor = UIColor(red: 120, green: 120, blue: 130)
        self.emptyCartSentence.textColor = UIColor(red: 120, green: 120, blue: 130)
        self.emptyCartSentence.font = UIFont.systemFont(ofSize: 15)
        self.selectionStyle = .none
    }

    internal func configureEmptyCartCell() {
        let firstName = UserAccount.shared.customerInfo?.firstName ?? ""
        self.emptyCartImageView.image = R.image.empty_cart()
        self.emptyCartTitleLabel.text = "Votre panier est vide"
        self.emptyCartDescLabel.text = "Nous avons des suggestions d'achats personnalisées pour vous"
        self.emptyCartDescLabel.attributedText = NSMutableAttributedString.init()
            .custom(firstName, font: UIFont.boldSystemFont(ofSize: 21), color: .lpPurple)
            .custom(" n'attendez plus pour faire vos achats !", font: UIFont.systemFont(ofSize: 21), color: .lpDeepBlue)
        self.emptyCartSentence.text = "En manque d'inspiration ? Laissez-vous guider."
    }

}
