//
//  EmptyFavoritesProductsTableViewCell.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 28/08/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class EmptyFavoritesProductsTableViewCell: UITableViewCell {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var noProductLabel: UIView!
    @IBOutlet weak var noProductImageView: UIImageView!
    @IBOutlet weak var suggestionLabel: UILabel!
    @IBOutlet weak var howToLabel: UILabel!
    @IBOutlet weak var emptyFavoritesLabel: UILabel!
    
    var type: TableViewType?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupCell()
    }
    
    internal func setupCell() {
        self.setupImageBesideLabel()
        self.noProductImageView.image = UIImage(named: "no_favorites")
        
        if self.type == .favorites {
            self.suggestionLabel.attributedText =
                NSMutableAttributedString()
                    .custom("\(UserAccount.shared.customerInfo?.firstName ?? "")", font: UIFont.boldSystemFont(ofSize: 18), color: .lpPurple)
                    .custom(" ajoutez un produit à vos favoris", font: UIFont.systemFont(ofSize: 18), color: .lpDeepBlue)
            self.emptyFavoritesLabel.text = "Aucun produit favori"
        } else {
            self.suggestionLabel.attributedText =
                NSMutableAttributedString()
                    .custom("\(UserAccount.shared.customerInfo?.firstName ?? "")", font: UIFont.boldSystemFont(ofSize: 18), color: .lpPurple)
                    .custom(" ajoutez un bureau de poste à vos favoris", font: UIFont.systemFont(ofSize: 18), color: .lpDeepBlue)
            self.emptyFavoritesLabel.text = "Aucun bureau de poste favori"
        }
    }
    
    private func setupImageBesideLabel() {
        let textAttachment = NSTextAttachment()
        textAttachment.image = UIImage(named: "add_favorite_purple")
        let attachmentString = NSAttributedString(attachment: textAttachment)
        if self.type == .favorites {
            let myString = NSMutableAttributedString(string: "Vous pouvez ajouter un produit à vos favoris grâce à l'icône ")
            myString.append(attachmentString)
            howToLabel.attributedText = myString
        } else {
            let myString = NSMutableAttributedString(string: "Vous pouvez ajouter un bureau de poste à vos favoris grâce à l'icône ")
            myString.append(attachmentString)
            howToLabel.attributedText = myString
        }
    }
}
