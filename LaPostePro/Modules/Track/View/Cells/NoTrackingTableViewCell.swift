//
//  NoTrackingTableViewCell.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 02/08/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class NoTrackingTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

}
