//
//  ProductCartInfoTableViewCell.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 25/03/2019.
//  Copyright © 2019 App Mobile. All rights reserved.
//

import UIKit

class ProductCartInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productCartInfoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(info: String, color: UIColor, bold: Bool) {
        self.productCartInfoLabel.text = info
        self.productCartInfoLabel.textColor = color
        if bold {
            self.productCartInfoLabel.font = UIFont.boldSystemFont(ofSize: 17)
        } else {
            self.productCartInfoLabel.font = UIFont.systemFont(ofSize: 17)
        }
    }

}
