//
//  LocationDetailHoursCell.swift
//  LaPostePro
//
//  Created by Issam DAHECH on 10/08/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class LocationDetailHoursCell: UITableViewCell {

    var delegate : LocationDetailCellDelegate?
    var codeSite : String?
    var hours    : [Any]?
    var retreiveDepositeHours : [Any]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func showCalendarClicked(_ sender: Any) {
        if let postalOfficeHours = hours , postalOfficeHours.count > 0 {
            delegate?.showHours(hours: postalOfficeHours)
        } else if let postalOfficeHours = retreiveDepositeHours , postalOfficeHours.count > 0 {
            delegate?.showRetieveDeposteHours(hours: postalOfficeHours)
        }
    }
    
}
