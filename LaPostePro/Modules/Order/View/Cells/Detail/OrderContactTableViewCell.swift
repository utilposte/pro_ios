//
//  OrderContactTableViewCell.swift
//  LaPostePro
//
//  Created by Matthieu Lemonnier on 07/09/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

protocol OrderDetailCellDelegate {
    func returnOrderTapped()
    func contactUsTapped()
}

class OrderContactTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var mainTextLabel: UILabel!
    @IBOutlet var buttonView: UIView!
    @IBOutlet var iconButtonImageView: UIImageView!
    @IBOutlet var textButtonLabel: UILabel!
    
    private var isContactCell = false
    
    var delegate: OrderDetailCellDelegate?

    func returnOrder() {
        self.titleLabel.text = "Pas totalement satisfait?"
        let mainText = NSMutableAttributedString()
        mainText.custom("Vous disposez d'un ", font: UIFont.systemFont(ofSize: 15), color: UIColor.black)
        
        mainText.custom("délai de 14 jours francs", font: UIFont.boldSystemFont(ofSize: 15), color: UIColor.black)
        mainText.custom(" à compter de la réception de votre commande pour effectuer votre demande.", font: UIFont.systemFont(ofSize: 15), color: UIColor.black)
        self.mainTextLabel.attributedText = mainText
        self.buttonView.backgroundColor = UIColor.lpDeepBlue
        self.textButtonLabel.text = "Retourner la commande"
        self.textButtonLabel.textColor = UIColor.white
        self.buttonView.borderColor = UIColor.clear
        self.buttonView.borderWidth = 0
        self.cornerRadius = 5
        self.iconButtonImageView.image = R.image.ic_btn_backorder()
        self.isContactCell = false

    }
    
    func contactUs() {
        self.titleLabel.text = "Un problème avec votre commande?"
        let mainText = NSMutableAttributedString()
        mainText.custom("Vous pouvez effectuez une demande d'assistance auprès de notre ", font: UIFont.systemFont(ofSize: 15), color: UIColor.black)
        
        mainText.custom("Service Clients", font: UIFont.boldSystemFont(ofSize: 15), color: UIColor.black)
        mainText.custom(" concernant un produit de votre commande.", font: UIFont.systemFont(ofSize: 15), color: UIColor.black)
        self.mainTextLabel.attributedText = mainText
        self.buttonView.backgroundColor = UIColor.white
        self.textButtonLabel.text = "Contactez-nous"
        self.textButtonLabel.textColor = UIColor.lpPurple
        self.buttonView.borderColor = UIColor.lpGrey
        self.buttonView.borderWidth = 1
        self.cornerRadius = 5
        self.iconButtonImageView.image = R.image.help_icon()
        self.isContactCell = true

    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func buttonClicked(_ sender: Any) {
        if isContactCell {
            contactUsTapped()
        } else {
            returnOrderTapped()
        }
    }
    
    @objc private func returnOrderTapped() {
        delegate?.returnOrderTapped()
    }
    
    @objc private func contactUsTapped() {
        delegate?.contactUsTapped()
    }
}
