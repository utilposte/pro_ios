//
//  TextFieldTableViewCell.swift
//  LPColissimoUI
//
//  Created by Yonael Tordjman on 26/10/2018.
//

import UIKit

protocol TextFieldTableViewCellDelegate: class {
    func crossButtonDidTapped(cell: TextFieldTableViewCell)
    func keyboardDidClosed(value: Double, cell: TextFieldTableViewCell)
    func textFieldDidEditing(cell: TextFieldTableViewCell)
}

class TextFieldTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textfieldValue: UITextField!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak open var gramLabel: UILabel!
    
    weak var delegate: TextFieldTableViewCellDelegate?
    var value: Double = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.textfieldValue.delegate = self
        self.actionButton.imageView?.contentMode = .scaleAspectFit
        self.actionButton.setImage(ColissimoHomeServices.loadImage(name: "clear.png"), for: .normal)
        self.textfieldValue.maxLength = 5
    }

    open func setupCell(placeholder: String, value: Double) {
        self.titleLabel.text = placeholder
        self.value = value
        self.textfieldValue.text = "\(self.value) Kg"
        self.textfieldValue.text = self.textfieldValue.text?.replacingOccurrences(of: ".", with: ",")
        self.gramLabel.text = " (soit \(Int(self.value * 1000)) g)"
        self.textfieldValue.addTarget(self, action: #selector(TextFieldTableViewCell.textfieldValueChanged), for: UIControl.Event.editingChanged)
        self.addDoneButtonOnKeyboard()
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        self.delegate?.crossButtonDidTapped(cell: self)
    }
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 50))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "OK", style: .done, target: self, action: #selector(ColissimoHomeViewController.doneButtonAction))
        doneButton.tintColor = .black
        doneToolbar.items = [flexibleSpace, doneButton]
        doneToolbar.setItems([flexibleSpace, doneButton], animated: true)
        
        self.textfieldValue.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        //        self.weightTextField.resignFirstResponder()
        self.textfieldValue.delegate = self
        _ = self.textfieldValue.delegate?.textFieldShouldReturn!(self.textfieldValue)
    }
    
    @objc func textfieldValueChanged() {
        let textInt = Double(self.textfieldValue.text ?? "") ?? 0
        self.gramLabel.text = "(soit \(Int(textInt * 1000)) g)"
    }
    
}

extension TextFieldTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textField.text = textField.text?.replacingOccurrences(of: " Kg", with: "")
        textField.text = textField.text?.replacingOccurrences(of: ",", with: ".")
        
        if let text = textField.text, text != "" {
            self.value = Double(text) ?? 0.0
        } else {
            self.value = 0
        }
        
        self.delegate?.keyboardDidClosed(value: self.value, cell: self)
        if self.value > 30 {
            self.value = 30
            textField.text = "30 Kg"
            self.gramLabel.text = "(soit \(30 * 1000)) g)"
        } else if self.value < 0.01 {
            self.value = 0.25
            textField.text = "0.25 Kg"
            self.gramLabel.text = "(soit \(0.25 * 1000)) g)"
        }
        
        self.setupCell(placeholder: "Poids", value: self.value)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = "\(self.value)"
        self.delegate?.textFieldDidEditing(cell: self)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty {
            return true
        }
        let currentText = textField.text ?? ""
        let replacementText = (currentText as NSString).replacingCharacters(in: range, with: string)
        return replacementText.isValidDouble(maxDecimalPlaces: 2)
    }
}
