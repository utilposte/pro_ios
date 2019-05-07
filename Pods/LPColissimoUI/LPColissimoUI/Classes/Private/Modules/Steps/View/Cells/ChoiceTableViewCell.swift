//
//  ChoiceTableViewCell.swift
//  LPColissimoUI
//
//  Created by Yonael Tordjman on 22/10/2018.
//

import UIKit

protocol ChoiceTableViewCellDelegate: class {
    func buttonDidTapped(cell: ChoiceTableViewCell)
}

class ChoiceTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    weak var delegate: ChoiceTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.actionButton.setImage(ColissimoHomeServices.loadImage(name: "select.png"), for: .normal)
        self.actionButton.imageView?.contentMode = .scaleAspectFit
    }

    func setupCell(title: String, value: String, action: String) {
        self.titleLabel.text = title
        self.valueLabel.text = value
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        self.delegate?.buttonDidTapped(cell: self)
    }
    
}
