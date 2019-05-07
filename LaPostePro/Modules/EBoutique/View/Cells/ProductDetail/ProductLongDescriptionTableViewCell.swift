//
//  ProductLongDescriptionTableViewCell.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 15/06/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class ProductLongDescriptionTableViewCell: UITableViewCell {

    @IBOutlet weak var longDescriptionExpandableLabel: ExpandableLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        longDescriptionExpandableLabel.collapsed = false
        // create attributed string for expanded label
        let expandedText = "Plus de détails"
        // create attributed string for collapsed label
        let collapsedText = "Moins de détails"
        let attributes = [ NSAttributedStringKey.foregroundColor: UIColor.lpPurple, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15, weight: .semibold) ]
        let expandedAttributedString = NSAttributedString(string: expandedText, attributes: attributes)
        
        
        longDescriptionExpandableLabel.collapsedAttributedLink = expandedAttributedString
        longDescriptionExpandableLabel.setLessLinkWith(lessLink: collapsedText, attributes: attributes, position: NSTextAlignment.left)
        longDescriptionExpandableLabel.numberOfLines = 3
        longDescriptionExpandableLabel.shouldCollapse = true
        longDescriptionExpandableLabel.textReplacementType = .character
    }

    func setupCell(feature: ProductFeature, isCollapsed: Bool) {
        longDescriptionExpandableLabel.text = feature.value?.htmlToString
        longDescriptionExpandableLabel.collapsed = isCollapsed

    }
}
