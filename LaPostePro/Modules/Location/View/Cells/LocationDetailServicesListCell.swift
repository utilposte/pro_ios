//
//  LocationDetailServicesListCell.swift
//  LaPostePro
//
//  Created by Issam DAHECH on 10/08/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class LocationDetailServicesListCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var listServicesLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setUpList(_ list : [String], isServices : Bool) {
        var title = "Accessibilité"
        if isServices == true {
            title = "Services proposés"
        }
        titleLabel.text = title
        
        var listString = ""
        for element in list {
            listString = listString + "• \(element)\n\n"
        }
        listServicesLabel.text = listString
    }
}
