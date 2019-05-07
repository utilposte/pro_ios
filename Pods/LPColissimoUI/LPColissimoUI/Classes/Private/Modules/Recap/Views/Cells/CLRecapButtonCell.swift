//
//  CLRecapButtonCell.swift
//  LPColissimoUI
//
//  Created by Yonael Tordjman on 07/01/2019.
//

import UIKit

protocol CLRecapButtonCellDelegate: class {
    func buttonDidTapped()
}
//

class CLRecapButtonCell: UITableViewCell {
    
    weak var delegate: CLRecapButtonCellDelegate?
    @IBOutlet weak var validateButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.validateButton.cornerRadius = self.validateButton.frame.height / 2
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        self.delegate?.buttonDidTapped()
    }
    
}
