//
//  TitleTableViewCell.swift
//  LPColissimoUI
//
//  Created by Yonael Tordjman on 19/11/2018.
//

import UIKit

class TitleTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }


    func setupCell(title: String) {
        self.title.text = title
    }
}
