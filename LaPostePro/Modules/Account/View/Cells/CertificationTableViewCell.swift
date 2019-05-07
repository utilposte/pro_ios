//
//  CertificationTableViewCell.swift
//  LaPostePro
//
//  Created by Lassad Tiss on 25/09/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit
protocol CertificationCellDelegate: class {
    func showInstructions()
}

class CertificationTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    weak var delegate: CertificationCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let formattedString = NSMutableAttributedString()
        formattedString
            .normal("Votre compte ")
            .custom("n’est pas certifié ", font: UIFont.systemFont(ofSize: 14, weight: .semibold), color: .black)
            .normal("par La Poste.")
        label.attributedText = formattedString
        
    }
    
    @IBAction func showInstructions(_ sender: UIButton) {
        delegate?.showInstructions()
    }
    
}
