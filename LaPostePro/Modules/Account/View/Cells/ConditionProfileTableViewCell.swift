//
//  ConditionProfileTableViewCell.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 17/08/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit
import ActiveLabel

class ConditionProfileTableViewCell: UITableViewCell {

   
    @IBOutlet weak var label: ActiveLabel!
    let serviceList = ActiveType.custom(pattern: "\\sici\\b")//Looks for "ici"
    let contactForm = ActiveType.custom(pattern: "\\sformulaire de contact\\b") //Looks for "formulaire de contact"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        setupCell()
    }
    
    internal func setupCell() {
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.lightGray
        label.enabledTypes = [.url, serviceList, contactForm]
        label.text = Constants.rgbdText
        label.sizeToFit()
        label.customColor[serviceList] = UIColor.lpPurple
        label.customColor[contactForm] = UIColor.lpPurple
        label.customize { (label) in
            label.URLColor = UIColor.lpPurple
            label.configureLinkAttribute = { (type, attributes, isSelected) in
                var atts = attributes
                atts[NSAttributedStringKey.font] = UIFont.systemFont(ofSize: 13, weight: .semibold)
                return atts
            }
        }
        label.handleURLTap { url in self.openWebView(for: url.absoluteString) }
        label.handleCustomTap(for: serviceList) { (element) in
            self.openWebView(for: WebViewURL.infoLiberte.rawValue)
        }
        label.handleCustomTap(for: contactForm) { (element) in
            self.openWebView(for: WebViewURL.contact.rawValue)
        }
    }
}
