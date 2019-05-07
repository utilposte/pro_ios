//
//  FormalitiesTitleTableViewCell.swift
//  LPColissimoUI
//
//  Created by Yonael Tordjman on 04/12/2018.
//

import UIKit

class FormalitiesTitleTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    func setupCell(title: String) {
        self.titleLabel.text = title
        self.titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        self.titleLabel.textColor = .black
    }

}
