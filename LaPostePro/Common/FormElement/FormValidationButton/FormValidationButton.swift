//
//  FormValidationButton.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 23/07/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

protocol ValidationButtonDelegate {
    func validationButtonClicked()
}

class FormValidationButton: UIView {
    
    
    @IBOutlet weak var validationButton: UIButton!
    var delegate: ValidationButtonDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func validationButtonClicked(_ sender: Any) {
        delegate?.validationButtonClicked()
    }
    
    func setup() {
        validationButton.cornerRadius = 20
        disableButton()
    }
    
    func enableButton() {
        validationButton.backgroundColor = UIColor.lpPurple
        validationButton.setTitleColor(.white, for: .normal)
        validationButton.isEnabled = true
    }
    
    func disableButton() {
        validationButton.backgroundColor = UIColor.lpGrayForInputTextBackround
        validationButton.setTitleColor(.lpGrey, for: .normal)
        validationButton.isEnabled = false
    }
    
}
