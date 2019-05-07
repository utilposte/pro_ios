//
//  AddTrackTableViewCell.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 02/08/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

protocol AddTrackTableViewCellDelegate: class {
    func trackButtonDidTapped()
}

class AddTrackTableViewCell: UITableViewCell {

    @IBOutlet weak var addTrackButton: UIButton!
    weak var delegate: AddTrackTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupTrackButton()
        self.selectionStyle = .none
    }
    
    private func setupTrackButton() {
        self.addTrackButton.layer.cornerRadius = self.addTrackButton.frame.size.height / 2
        self.addTrackButton.backgroundColor = .lpPurple
        self.addTrackButton.setTitle("Ajouter un colis à suivre", for: .normal)
        self.addTrackButton.setTitleColor(UIColor.white, for: .normal)
    }

    @IBAction func addTrackButtonTapped(_ sender: Any) {
        self.delegate?.trackButtonDidTapped()
    }
}
