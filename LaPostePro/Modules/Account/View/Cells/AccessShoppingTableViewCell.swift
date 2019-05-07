//
//  AccessShoppingTableViewCell.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 28/08/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

protocol AccessShoppingTableViewCellDelegate: class {
    func accessShoppingButtonDidTapped(cell: AccessShoppingTableViewCell)
}

class AccessShoppingTableViewCell: UITableViewCell {

    @IBOutlet weak var accessShoppingButton: UIButton!
    weak var delegate: AccessShoppingTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    internal func setupCell(title: String) {
        self.accessShoppingButton.layer.cornerRadius = self.accessShoppingButton.frame.height / 2
        self.accessShoppingButton.backgroundColor = .lpPurple
        self.accessShoppingButton.setTitle(title, for: .normal)
        self.accessShoppingButton.setTitleColor(.white, for: .normal)
    }
    
    @IBAction func AccessShoppingButtonTapped(_ sender: Any) {
        self.delegate?.accessShoppingButtonDidTapped(cell: self)
    }
    
}
