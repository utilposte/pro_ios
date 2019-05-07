//
//  StepTrackingTableViewCell.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 01/08/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class StepTrackingTableViewCell: UITableViewCell {

    @IBOutlet weak var stepRoundedView: UIView!
    @IBOutlet weak var stepDateLabel: UILabel!
    @IBOutlet weak var stepDescLabel: UILabel!
    @IBOutlet weak var stepTrackView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    internal func setupCell(title: String, desc: String, last: Bool) {
        self.stepRoundedView.layer.cornerRadius = self.stepRoundedView.frame.height / 2
        self.stepRoundedView.layer.borderWidth = 3
        self.stepRoundedView.backgroundColor = .white
        self.stepRoundedView.layer.borderColor = UIColor.lpPurple.cgColor
        self.stepTrackView.backgroundColor = UIColor.lpPurple
        self.stepDateLabel.textColor = .lpPurple
        self.stepTrackView.isHidden = last
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss+SSSS"
        dateFormatter.locale = Locale.current
        let givenDate: Date = dateFormatter.date(from: title) ?? Date()
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateStyle = .short
        let dateString = dateFormatter2.string(from: givenDate)
        
        self.stepDateLabel.text = dateString
        self.stepDescLabel.text = desc
    }
}
