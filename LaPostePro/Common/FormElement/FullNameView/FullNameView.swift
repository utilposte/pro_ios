//
//  FullNameView.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 20/07/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialTextFields

protocol FullNameViewDelegate {
    func textFieldEndEditing()
}

class FullNameView: UIView {

    @IBOutlet weak private var lastNameTextField: MDCTextField!
    @IBOutlet weak private var firstNameTextField: MDCTextField!
    private var firstNameTextfieldController: MDCTextInputControllerFilled?
    private var lastNameTextfieldController: MDCTextInputControllerFilled?
    var delegate: FullNameViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //setupView()
    }
    
    func setupView() {
        lastNameTextField.delegate = self
        firstNameTextField.delegate = self
        self.firstNameTextfieldController = MDCTextInputControllerFilled(textInput: firstNameTextField)
        self.firstNameTextField.placeholderLabel.text = "Prénom"
        self.lastNameTextfieldController = MDCTextInputControllerFilled(textInput: lastNameTextField)
        self.lastNameTextField.placeholderLabel.text = "Nom"
        
        self.firstNameTextfieldController?.activeColor = .lpDeepBlue
        self.firstNameTextfieldController?.floatingPlaceholderActiveColor = .lpDeepBlue
        
        self.lastNameTextfieldController?.activeColor = .lpDeepBlue
        self.lastNameTextfieldController?.floatingPlaceholderActiveColor = .lpDeepBlue

    }
    
    func getFirstNameText() -> String{
        return firstNameTextField.text ?? ""
    }
    func getLastNameText() -> String {
        return lastNameTextField.text ?? ""
    }
    
    func setLastNameText(lastName: String) {
        if !lastName.isEmpty {
            lastNameTextField.text = lastName
        }
    }
    func setFirstNameText(firstName: String) {
        if !firstName.isEmpty {
           firstNameTextField.text = firstName
        }
    }
    func isValidFullName() -> Bool {
        return !((firstNameTextField.text?.isEmpty)! && (firstNameTextField.text?.isEmpty)!)
    }
}

extension FullNameView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.textFieldEndEditing()
    }
}
