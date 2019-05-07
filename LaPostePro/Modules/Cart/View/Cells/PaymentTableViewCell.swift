//
//  PaymentTableViewCell.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 18/07/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

protocol PaymentTableViewCellDelegate: class {
    func payTapped()
}

class PaymentTableViewCell: UITableViewCell {

    @IBOutlet weak var paymentButton: UIButton!
    weak var delegate: PaymentTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func setupPaymentCell(isEnabled: Bool) {
        self.paymentButton.setTitleColor(.white, for: .normal)
        self.paymentButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        if isEnabled {
            self.paymentButton.backgroundColor = .lpPurple
        } else {
            self.paymentButton.backgroundColor = .lightGray
        }
        self.paymentButton.isEnabled = isEnabled
        self.paymentButton.cornerRadius = self.paymentButton.frame.size.height / 2
    }
    
    @IBAction func payTapped(_ sender: Any) {
        delegate?.payTapped()
    }
}
