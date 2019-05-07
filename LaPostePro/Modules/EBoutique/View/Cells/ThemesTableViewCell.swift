//
//  ThemesTableViewCell.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 14/06/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class ThemesTableViewCell: UITableViewCell {

    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet weak var isCheckedImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
