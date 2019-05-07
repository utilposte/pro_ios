//
//  CGVConditionTableViewCell.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 18/07/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit
import ActiveLabel

protocol CGVConditionTableViewCellDelegate: class {
    func cgvCondidionButtonDidTapped()
}

class CGVConditionTableViewCell: UITableViewCell {

    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var conditionButton: UIButton!
    @IBOutlet weak var checkBoxView: UIView!
    @IBOutlet weak var cgvTermsLabelContainerView: UIView!
    
    
    weak var delegate: CGVConditionTableViewCellDelegate?
    let sellsCgu = ActiveType.custom(pattern: "\\sConditions Générales de Vente\\b")
    let dangerousItemsCgu = ActiveType.custom(pattern: "\\smarchandises dangereuses et interdites\\b")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func setupCGVCell(CGVCheck: Bool) {
        self.checkImage.isHidden = !CGVCheck
        self.checkBoxView.layer.cornerRadius = 5
        self.checkBoxView.layer.borderWidth = 0.5
        self.checkBoxView.layer.borderColor = UIColor.black.cgColor
        self.checkImage.tintColor = .lpPurple
        
        let activeLabel = ActiveLabel()
        activeLabel.frame = cgvTermsLabelContainerView.frame
        activeLabel.numberOfLines = 0
        activeLabel.font = UIFont.systemFont(ofSize: 15)
        activeLabel.textColor = UIColor.lpDeepBlue
        activeLabel.enabledTypes = [sellsCgu, dangerousItemsCgu]
        activeLabel.text = Constants.cgvText
        activeLabel.sizeToFit()
        activeLabel.customize { (label) in
            label.configureLinkAttribute = { (type, attributes, isSelected) in
                var atts = attributes
                atts[NSAttributedStringKey.underlineStyle] = NSUnderlineStyle.styleSingle.rawValue
                return atts
            }
        }
        
        activeLabel.handleCustomTap(for: sellsCgu) { (element) in
            self.openWebView(for: WebViewURL.conditionGeneral.rawValue)
        }
        activeLabel.handleCustomTap(for: dangerousItemsCgu) { (element) in
            self.openWebView(for: WebViewURL.dangereux.rawValue)
        }
        
        cgvTermsLabelContainerView.addSubview(activeLabel)
        activeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activeLabel.topAnchor.constraint(equalTo: cgvTermsLabelContainerView.topAnchor, constant: 0),
            activeLabel.leftAnchor.constraint(equalTo: cgvTermsLabelContainerView.leftAnchor, constant: 0),
            activeLabel.rightAnchor.constraint(equalTo: cgvTermsLabelContainerView.rightAnchor, constant: 0),
            activeLabel.bottomAnchor.constraint(equalTo: cgvTermsLabelContainerView.bottomAnchor, constant: 0)
            ])
        
        self.layoutIfNeeded()
    }
    
    @IBAction func conditionButtonTapped(_ sender: Any) {
        self.delegate?.cgvCondidionButtonDidTapped()
    }
    
}
