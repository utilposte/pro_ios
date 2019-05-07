//
//  OrderDateTableViewCell.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 31/07/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class OrderDateTableViewCell: UITableViewCell {

    @IBOutlet weak var orderDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    internal func setupCell(date: String, status: Bool) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss+SSSS"
        dateFormatter.locale = Locale.current
        let givenDate: Date = dateFormatter.date(from: date) ?? Date()
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateStyle = .long
        let dateString = dateFormatter2.string(from: givenDate)
        //JIRA APPPRO-543
//        var state = ""
//
//        if status {
//            state = "Livré"
//        } else {
//            state = "En cours"
//        }
        
        self.orderDateLabel.attributedText = NSMutableAttributedString()
        .custom("Commandé le \(dateString) ", font: UIFont.systemFont(ofSize: 15), color: .lpGrey)
        //.custom(state, font: UIFont.systemFont(ofSize: 15), color: .lpDeepBlue)
    }

}
