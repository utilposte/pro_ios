//
//  DualSixthPriceTableViewCell.swift
//  LPColissimoUI
//
//  Created by Yonael Tordjman on 27/11/2018.
//

import UIKit

enum SixthPrice {
    case title
    case info
    
    var textColor: UIColor {
        switch self {
        case .title:
            return .white
        case .info:
            return UIColor.init(red: 60/255, green: 60/255, blue: 59/255, alpha: 1)
        }
        
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .title:
            return .lpOrange
        case .info:
            return UIColor.init(red: 217/255, green: 217/255, blue: 217/255, alpha: 1)
        }
    }
}

class DualSixthPriceTableViewCell: UITableViewCell {

    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var firstLabel: UILabel!
    
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var secondLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func setupCell(firstTitle: String, secondTitle: String, type: SixthPrice) {
        
        self.firstView.backgroundColor = type.backgroundColor
        self.secondView.backgroundColor = type.backgroundColor
        
        self.firstLabel.textColor = type.textColor
        self.secondLabel.textColor = type.textColor
        
        self.firstLabel.text = firstTitle
        self.secondLabel.text = secondTitle
    }

}
