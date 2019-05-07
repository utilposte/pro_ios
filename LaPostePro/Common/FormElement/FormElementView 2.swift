//
//  FormElementView.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 09/07/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import Foundation
import UIKit
import MaterialComponents.MaterialTextFields

//MARK: PROTOCOLS
protocol FormElementViewDelegate: class {
    func textfieldDidTapped(textfield: MDCTextField, action: FormElementDataPicker)
    func textFieldDidEndEditing(textfield: UITextField)
}

enum FormElementInputTextType {
    case email
    case postalCode
    case internationalPostalCode
    case customerId
    case none
}

//MARK: ENUMERATIONS
enum FormElementAction {
    case picker(type: FormElementDataPicker)
    case none
}

enum FormElementDataPicker: Equatable {
    case country(countryList: [DataCountry])
    case company(companyTypeList: [CompanyType])
    
    var value: [String] {
        switch self {
        case .country(let countryList):
            return countryList.map { $0.name! }
        case .company(let companyTypeList):
            return companyTypeList.map { $0.name! }
        }
    }
    
    static func == (lhs: FormElementDataPicker, rhs: FormElementDataPicker) -> Bool {
        switch (lhs, rhs) {
        case (.country,   .country):
            return true
        case (.company,   .company):
            return true
        default:
            return false
        }
    }
}

//MARK: CUSTOMVIEW
class FormElementView: UIView {
    
    internal var textfield: MDCTextField?
    internal var textfieldController: MDCTextInputControllerFilled?
    internal var typeOfData: FormElementDataPicker?
    internal var currentFormStruct: FormElementStruct?
    
    weak var delegate: FormElementViewDelegate?
    
    init() { super.init(frame: CGRect.zero) }
    
    init(_ formStruct: FormElementStruct) {
        super.init(frame: CGRect.zero)
        self.backgroundColor = .white
        self.textfield = MDCTextField()
        self.textfieldController = MDCTextInputControllerFilled(textInput: textfield)
        self.textfield?.cornerRadius = 5
        self.textfield?.autocapitalizationType = .none
        self.addSubview(self.textfield!)
        self.initViews(formStruct: formStruct)
    }
    
    func getText() -> String {
        return self.textfield?.text ?? ""
    }
    
    func setText(text: String) {
        if !text.isEmpty {
         self.textfield?.text = text
        }
    }
    
    func isRequired() -> Bool {
        return currentFormStruct?.isRequired ?? false
    }
    func initViews(formStruct: FormElementStruct) {
        self.currentFormStruct = formStruct
        guard let textfield = self.textfield, let textfieldController = self.textfieldController else { return }
        
        //Keyboard type
        switch formStruct.elementType {
        case .email?:
            textfield.keyboardType = UIKeyboardType.emailAddress
        case .postalCode?:
            textfield.keyboardType = UIKeyboardType.numberPad
        default:
            textfield.keyboardType = UIKeyboardType.default
            
        }
        //DEFAULT VALUE
        if let value = formStruct.defaultValue {
            textfield.text = value
        }

        textfield.delegate = self
        // REQUIRED
        if formStruct.isRequired {
            textfieldController.placeholderText = "\(formStruct.placeholder ?? "")*"
        } else {
            textfieldController.placeholderText = formStruct.placeholder ?? ""
        }
        
        // DISPLAYED
        
        textfieldController.accessibilityHint = "test"
        
        if formStruct.isDisplayed {
            self.isHidden = false
        } else {
            self.isHidden = true
        }
        
        // ACTION
        switch formStruct.action {
        case .picker(let type):
            textfield.rightView = UIImageView(image: R.image.downArrow())
            textfield.rightViewMode = .always
            self.typeOfData = type
            self.textfieldController?.borderFillColor = UIColor.white
            self.textfieldController?.expandsOnOverflow = false
            textfield.isEnabled = false
            self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(FormElementView.elementTapped)))
        default:
            textfield.isEnabled = true
        }
        
        // SECURED
        if formStruct.isSecured {
            let eyeButton = UIButton(type: .custom)
            eyeButton.addTarget(self, action: #selector(FormElementView.eyeButtonTapped), for: .touchUpInside)
            eyeButton.frame = CGRect(x: CGFloat(textfield.frame.size.width - 25), y: CGFloat(5), width: CGFloat(20), height: CGFloat(20))
            if formStruct.shouldSeePassword {
                eyeButton.setBackgroundImage(UIImage(named: "eye_close"), for: .normal)
            }
            else {
                eyeButton.setBackgroundImage(UIImage(named: "eye"), for: .normal)
            }
            
            textfield.rightView = eyeButton
            textfield.rightViewMode = .always
            textfield.isSecureTextEntry = formStruct.shouldSeePassword
        } else {
            textfield.isSecureTextEntry = false
        }
        
        if let helperText = formStruct.helperText {
            textfield.leadingUnderlineLabel.textColor = UIColor.darkGray
            textfield.leadingViewMode = .always
            textfield.leadingUnderlineLabel.text = helperText
            textfield.leadingUnderlineLabel.numberOfLines = 2
            textfield.leadingUnderlineLabel.font = UIFont.systemFont(ofSize: 8)
        }
        
        self.noErrorStyle()
        
        textfield.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textfield.topAnchor.constraint(equalTo: self.topAnchor),
            textfield.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            textfield.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            textfield.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
            self.heightAnchor.constraint(equalToConstant: 80),
            ])
    }
    
    @objc func eyeButtonTapped() {
        guard var form = self.currentFormStruct else { return }
        if form.shouldSeePassword == false {
            form.shouldSeePassword = true
        } else {
            form.shouldSeePassword = false
        }
        
        self.initViews(formStruct: form)
    }
    
    @objc func elementTapped() {
        guard let textfield = self.textfield, let typeOfData = self.typeOfData else { return }
        self.delegate?.textfieldDidTapped(textfield: textfield, action: typeOfData)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupErrorStyle(errorText: String?) {
        self.textfieldController?.setErrorText(errorText, errorAccessibilityValue: errorText)
        self.textfieldController?.activeColor = .red
        self.textfieldController?.floatingPlaceholderActiveColor = .red
    }
    
    func noErrorStyle() {
        self.textfieldController?.setErrorText(nil, errorAccessibilityValue: nil)
        self.textfieldController?.activeColor = .lpDeepBlue
        self.textfieldController?.floatingPlaceholderActiveColor = .lpDeepBlue
    }
}

extension FormElementView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.delegate?.textFieldDidEndEditing(textfield: textField)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var maxLength = 1
        switch self.currentFormStruct?.elementType {
        case .postalCode?:
            maxLength = 5
        case .internationalPostalCode?:
            maxLength = 38
        case .customerId?:
            maxLength = 8
        default:
            maxLength = 200
        }
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
}

//MARK: STRUCT
struct FormElementStruct {
    var placeholder: String?
    var helperText: String?
    var errorText: String?
    var isRequired: Bool = false
    var isDisplayed: Bool = true
    var action: FormElementAction
    var isSecured: Bool = false
    var defaultValue: String?
    var shouldSeePassword: Bool = false
    var elementType: FormElementInputTextType?
}
