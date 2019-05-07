//
//  ProductCartColissimoDetailTableViewCell.swift
//  LaPostePro
//
//  Created by Issam DAHECH on 12/04/2019.
//  Copyright © 2019 App Mobile. All rights reserved.
//

import UIKit

class ProductCartColissimoDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var productCartColissimoDetailLabel: UILabel!
    @IBOutlet weak var productCartColissimoTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func setupCell(title: String, detail: String?) {
        self.productCartColissimoTitleLabel.text = title
        self.productCartColissimoDetailLabel.text = detail ?? "NA"
    }
}
