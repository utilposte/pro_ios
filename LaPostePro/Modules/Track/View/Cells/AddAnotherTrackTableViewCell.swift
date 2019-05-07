//
//  AddAnotherTrackTableViewCell.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 03/08/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class AddAnotherTrackTableViewCell: UITableViewCell {

    @IBOutlet weak var buttonView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.buttonView.layer.cornerRadius = 5
        self.selectionStyle = .none
    }
    
}
