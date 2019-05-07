//
//  LocationCalendarTableViewCell.swift
//  LaPostePro
//
//  Created by Lassad Tiss on 03/08/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class LocationCalendarTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var workingHoursLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
