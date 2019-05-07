//
//  RgbdView.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 18/07/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit
import ActiveLabel

class RgpdView: UIView {
    
    // custom type for Active label
    let serviceList = ActiveType.custom(pattern: "\\sici\\b")//Looks for "ici"
    let contactForm = ActiveType.custom(pattern: "\\sformulaire de contact\\b") //Looks for "formulaire de contact"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupText()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupText()
    }
    
    func setupText() {
        let activeLabel = ActiveLabel()
        activeLabel.frame = CGRect.zero
        activeLabel.numberOfLines = 0
        activeLabel.font = UIFont.systemFont(ofSize: 13)
        activeLabel.textColor = UIColor.lightGray
        activeLabel.enabledTypes = [.url, serviceList, contactForm]
        activeLabel.text = Constants.rgbdText
        activeLabel.sizeToFit()
        activeLabel.customColor[serviceList] = UIColor.lpPurple
        activeLabel.customColor[contactForm] = UIColor.lpPurple
        activeLabel.customize { (label) in
            label.URLColor = UIColor.lpPurple
            label.configureLinkAttribute = { (type, attributes, isSelected) in
                var atts = attributes
                atts[NSAttributedStringKey.font] = UIFont.systemFont(ofSize: 13, weight: .semibold)
                return atts
            }
        }
        activeLabel.handleURLTap { url in self.openWebView(for: url.absoluteString) }
        activeLabel.handleCustomTap(for: serviceList) { (element) in
            self.openWebView(for: WebViewURL.infoLiberte.rawValue)
        }
        activeLabel.handleCustomTap(for: contactForm) { (element) in
            self.openWebView(for: WebViewURL.contact.rawValue)
        }
        self.addSubview(activeLabel)
        activeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            activeLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            activeLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
            activeLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20)
            ])
    }
}
