//
//  DeleteAccountTableViewCell.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 14/08/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit


protocol DeleteAccountTableViewCellDelegate {
    func deleteAccount()
}

class DeleteAccountTableViewCell: UITableViewCell {

    var delegate : DeleteAccountTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    @IBAction func deleteAccountClicked() {
        delegate?.deleteAccount()
    }
}
