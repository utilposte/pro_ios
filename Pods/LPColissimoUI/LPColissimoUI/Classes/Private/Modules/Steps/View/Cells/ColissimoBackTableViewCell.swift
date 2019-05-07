//
//  ColissimoBackTableViewCell.swift
//  LPColissimoUI
//
//  Created by Yonael Tordjman on 21/11/2018.
//

import UIKit

class ColissimoBackTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var backSwitch: UISwitch!
    @IBOutlet weak var backPaidLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }
    
    func setupCell() {
        self.backSwitch.onTintColor = .lpOrange
        self.backPaidLabel.textColor = .lpOrange
        
        let titleAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)]
        
        let titleString = NSAttributedString(string: " En savoir plus.", attributes: titleAttributes)
        
        let title2Attributes = [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        
        let title2String = NSAttributedString(string: "Le retour du colis est facturé à l’expéditeur. Les frais d’acheminement en retour correspondent au montant de l’affranchissement payé pour l’envoi initial.", attributes: title2Attributes)
        
        let finalString = NSMutableAttributedString.init(attributedString: title2String)
        finalString.append(titleString)
        
        self.content.attributedText = finalString
        
    }

}
