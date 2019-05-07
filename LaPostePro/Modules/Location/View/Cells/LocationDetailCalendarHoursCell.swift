//
//  LocationDetailCalendarHoursCell.swift
//  LaPostePro
//
//  Created by Issam DAHECH on 04/10/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class LocationDetailCalendarHoursCell: UITableViewCell {

    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpCell(data : [String]) {
        if data.count == 0 {
            hoursLabel.text = "Fermé"
            hoursLabel.textColor = UIColor.lpRedForUnavailableProduct
        }
        else {
            var hourText = ""
            for hour in data {
               hourText = hourText + hour + "\n"
            }
            hourText.remove(at: hourText.index(before: hourText.endIndex))
            hoursLabel.text = hourText
        }
        
    }
}
