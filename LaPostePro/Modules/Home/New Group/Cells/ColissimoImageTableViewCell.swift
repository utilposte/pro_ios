//
//  ColissimoImageTableViewCell.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 26/02/2019.
//  Copyright © 2019 App Mobile. All rights reserved.
//

import UIKit

protocol ColissimoImageTableViewCellDelegate: class {
    func cellDidTapped()
}

class ColissimoImageTableViewCell: UITableViewCell {

    @IBOutlet weak var colissimoImage: UIImageView!
    
    weak var delegate: ColissimoImageTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(image: String) {
        self.colissimoImage.image = UIImage.init(named: image)
    }
    
    
    @IBAction func buttonTapped(_ sender: Any) {
        self.delegate?.cellDidTapped()
    }
    
}
