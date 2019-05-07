//
//  NoCurrentTrackTableViewCell.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 03/08/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

protocol NoCurrentTrackTableViewCellDelegate: class {
    func searchButtonDidTapped()
}

class NoCurrentTrackTableViewCell: UITableViewCell {

    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    
    weak var delegate: NoCurrentTrackTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.mainLabel.text = "Vous n'avez pas de suivi en cours"
        self.subLabel.text = "Tous vos suivis de colis sont terminés."
        
        self.searchButton.layer.cornerRadius = self.searchButton.frame.size.height / 2
        self.searchButton.backgroundColor = .lpPurple
        self.searchButton.setTitle("Rechercher un suivi", for: .normal)
        self.searchButton.setTitleColor(UIColor.white, for: .normal)
    }
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        self.delegate?.searchButtonDidTapped()
    }
}
