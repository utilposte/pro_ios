//
//  FormalitiesButtonTableViewCell.swift
//  LPColissimoUI
//
//  Created by Yonael Tordjman on 04/12/2018.
//

import UIKit

class FormalitiesButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var actionButtonConstraintLeading: NSLayoutConstraint!
    @IBOutlet weak var actionButtonConstraintTrailing: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.actionButton.isEnabled = false
    }
    
    func setupCell(title: String, color: UIColor) {
        self.actionButton.setTitle(title, for: .normal)
        self.actionButton.setTitleColor(.white, for: .normal)
        self.actionButton?.backgroundColor = color
        self.actionButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        
        self.actionButton.layer.cornerRadius = self.actionButton.frame.height / 2
    }
}
