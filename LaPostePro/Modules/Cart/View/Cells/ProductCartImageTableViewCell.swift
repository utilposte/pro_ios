//
//  ProductCartImageTableViewCell.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 25/03/2019.
//  Copyright © 2019 App Mobile. All rights reserved.
//

import UIKit

class ProductCartImageTableViewCell: UITableViewCell {

    @IBOutlet weak var productCartImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func setupCell(image: String) {
        self.productCartImage.image = UIImage.init(named: image)
    }

}
