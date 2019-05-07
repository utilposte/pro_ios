//
//  SectionTableViewCell.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 14/08/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

protocol SectionTableViewCellDelegate: class {
    func buttonDidTapped(isAdress: Bool, cell: SectionTableViewCell)
}

class SectionTableViewCell: UITableViewCell {

    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var sectionTitle: UILabel!
    weak var delegate:SectionTableViewCellDelegate?
    var isAdressString: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    internal func setupCell(title: String) {
        self.sectionTitle.text = title
        self.isAdressString = title
    }

    @IBAction func updateButtonTapped(_ sender: Any) {
        if let isAdress = self.isAdressString {
            if isAdress.contains("Adresse") {
                self.delegate?.buttonDidTapped(isAdress: true, cell: self)
            } else {
                self.delegate?.buttonDidTapped(isAdress: false, cell: self)
            }
        }
    }
}
