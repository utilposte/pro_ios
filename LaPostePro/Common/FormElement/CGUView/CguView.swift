//
//  File.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 18/07/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit
import ActiveLabel

protocol CGUDelegate {
    func validateForm()
    func cguChecked(cguChecked: Bool)
}

class CguView: UIView {
    //MARK: PROPRETIES
    var delegate: CGUDelegate?
    let viewModel = CompanyInformationViewModel()
    var cguChecked = false
    var hideOptionalsFields = true
    
    let courrierColisCgu = ActiveType.custom(pattern: "\\sConditions Générales Courrier-Colis\\b")
    let eboutiqueCgu = ActiveType.custom(pattern: "\\sconditions spécifiques boutique\\b")
    let posteCgu = ActiveType.custom(pattern: "\\sconditions générales d'Utilisation du compte La Poste\\b")
    
    //OUTLETS
    @IBOutlet weak var formValidationButton: UIButton!
    @IBOutlet weak var cguLabel: UILabel!
    @IBOutlet weak var cguButton: UIButton!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup() {
        let activeLabel = ActiveLabel()
        activeLabel.frame = cguLabel.frame
        activeLabel.numberOfLines = 0
        activeLabel.font = UIFont.systemFont(ofSize: 15)
        activeLabel.textColor = UIColor.lpDeepBlue
        activeLabel.enabledTypes = [courrierColisCgu, eboutiqueCgu, posteCgu]
        activeLabel.text = Constants.cguText
        activeLabel.sizeToFit()
        activeLabel.customize { (label) in
            label.configureLinkAttribute = { (type, attributes, isSelected) in
                var atts = attributes
                atts[NSAttributedStringKey.underlineStyle] = NSUnderlineStyle.styleSingle.rawValue
                return atts
            }
        }
        
        activeLabel.handleCustomTap(for: courrierColisCgu) { (element) in
            self.openWebView(for: WebViewURL.conditionGeneral.rawValue)
        }
        activeLabel.handleCustomTap(for: eboutiqueCgu) { (element) in
            self.openWebView(for: WebViewURL.conditionGeneral.rawValue)
        }
        activeLabel.handleCustomTap(for: posteCgu) { (element) in
            self.openWebView(for: WebViewURL.conditionGeneral.rawValue)
        }
        
        self.addSubview(activeLabel)
        activeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activeLabel.topAnchor.constraint(equalTo: cguLabel.topAnchor, constant: 0),
            activeLabel.leftAnchor.constraint(equalTo: cguLabel.leftAnchor, constant: 0),
            activeLabel.rightAnchor.constraint(equalTo: cguLabel.rightAnchor, constant: 0),
            activeLabel.bottomAnchor.constraint(equalTo: cguLabel.bottomAnchor, constant: 0)
            ])
        
        formValidationButton.cornerRadius = 20
        cguButton.borderColor = .lpGrey
        cguButton.borderWidth = 1
        cguButton.cornerRadius = 3
    }
    @IBAction func cguButtonClicked(_ sender: Any) {
        cguChecked = !cguChecked
        if cguChecked {
            cguButton.setImage(R.image.smallCheck(), for: .normal)
            delegate?.cguChecked(cguChecked: cguChecked)
        } else {
            cguButton.setImage(UIImage(), for: .normal)
            delegate?.cguChecked(cguChecked: cguChecked)
        }
    }
    
    
    @IBAction func createAccountButtonClicked(_ sender: Any) {
        if delegate != nil {
            delegate?.validateForm()
        }
    }
    
    func enableValidation(with buttonTitle: String) {
        self.formValidationButton.setTitle(buttonTitle, for: .normal)
        self.formValidationButton.isEnabled = true
        self.formValidationButton.backgroundColor = .lpPurple
        self.formValidationButton.setTitleColor(.white, for: .normal)
    }
    func disableValidation(with buttonTitle: String) {
        self.formValidationButton.setTitle(buttonTitle, for: .normal)
        self.formValidationButton.isEnabled = false
        self.formValidationButton.backgroundColor = .lpGrayShadow
        self.formValidationButton.setTitleColor(.lpGrey, for: .normal)
    }
}

