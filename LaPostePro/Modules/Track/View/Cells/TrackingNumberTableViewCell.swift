//
//  TrackingNumberTableViewCell.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 31/07/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class TrackingNumberTableViewCell: UITableViewCell {

    @IBOutlet weak var trackingNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    internal func setupCell(trackingNumber: String) {
        self.trackingNumber.text = "n° \(trackingNumber)"
    }
}
