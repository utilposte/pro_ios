//
//  WelcomeCell.swift
//  Pods
//
//  Created by LaPoste on 28/11/2018.
//

import UIKit

class WelcomeCell: LPBaseCustomCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    func setup(name : String){
        self.titleLabel.text = "Bonjour \(name), votre adresse a été renseignée automatiquement."
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
