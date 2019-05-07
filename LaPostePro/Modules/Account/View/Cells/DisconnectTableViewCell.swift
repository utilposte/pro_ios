//
//  DisconnectTableViewCell.swift
//  LaPostePro
//
//  Created by Lassad Tiss on 05/07/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

protocol DisconnectTableViewCellDelegate: class {
    func didTappedDisconnect()
}

class DisconnectTableViewCell: UITableViewCell {

    @IBOutlet weak var disconnectButton: UIButton!
    
    weak var delegate: DisconnectTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func disconnect(_ sender: UIButton) {
        delegate?.didTappedDisconnect()
    }
}
