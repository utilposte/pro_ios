//
//  ButtonTableViewCell.swift
//  LPColissimoUI
//
//  Created by Yonael Tordjman on 22/10/2018.
//

import UIKit

protocol ButtonTableViewCellDelegate: class {
    func buttonDidTapped(cell: ButtonTableViewCell)
}

class ButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var nextButton: UIButton!
    
    weak var delegate: ButtonTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func setupCell(title: String) {
        self.nextButton.setTitle(title.uppercased(), for: .normal)
        self.nextButton.setTitleColor(.white, for: .normal)
        self.nextButton.backgroundColor = UIColor.init(red: 29/255, green: 179/255, blue: 132/255, alpha: 1)
        self.nextButton.cornerRadius = self.nextButton.frame.size.height / 2
        self.nextButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        self.delegate?.buttonDidTapped(cell: self)
    }
    
}
