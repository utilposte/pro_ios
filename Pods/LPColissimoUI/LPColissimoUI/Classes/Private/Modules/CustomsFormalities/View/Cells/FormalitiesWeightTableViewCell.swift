//
//  FormalitiesWeightTableViewCell.swift
//  LPColissimoUI
//
//  Created by Yonael Tordjman on 30/11/2018.
//

import UIKit

protocol FormalitiesWeightTableViewCellDelegate: class {
    func weightDidChanged(weight: Double)
    func precisionTextDidChange(text: String)
}

class FormalitiesWeightTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueTextfield: UITextField!
    @IBOutlet weak var separatorView: UIView!
    weak var delegate: FormalitiesWeightTableViewCellDelegate?
    var isWeight = false
    var maxValue: Double = 30
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func setupCell(title: String, value: String) {
        self.valueTextfield.addTarget(self, action: #selector(FormalitiesWeightTableViewCell.textFieldDidChange), for: .editingChanged)
        self.titleLabel.text = title
        self.valueTextfield.text = value
        self.separatorView.backgroundColor = UIColor.lpGrey
        if self.isWeight {
            self.addDoneButtonOnKeyboard(textfield: self.valueTextfield)
            self.valueTextfield.keyboardType = .decimalPad
        } else {
            self.valueTextfield.keyboardType = .default
        }
        
        self.valueTextfield.delegate = self
    }
    
    func addDoneButtonOnKeyboard(textfield: UITextField) {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 50))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "OK", style: .done, target: self, action: #selector(FormalitiesArticleOtherTableViewCell.doneButtonAction))
        doneButton.tintColor = .black
        doneToolbar.items = [flexibleSpace, doneButton]
        doneToolbar.setItems([flexibleSpace, doneButton], animated: true)
        
        textfield.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        _ = self.valueTextfield.delegate?.textFieldShouldReturn!(self.valueTextfield)
    }
    
    @objc func textFieldDidChange() {
        self.delegate?.precisionTextDidChange(text: self.valueTextfield.text ?? "")
    }

}

extension FormalitiesWeightTableViewCell: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.valueTextfield.text = textField.text?.replacingOccurrences(of: " kg", with: "")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if self.isWeight {
            let textValue = textField.text ?? "0.25"
            var doubleValue = Double.init(textValue) ?? 0.25
            if doubleValue < 0.01 {
                doubleValue = 0.25
            } else if doubleValue > maxValue {
                doubleValue = maxValue
            }
            textField.text?.append(" kg")
            self.delegate?.weightDidChanged(weight: doubleValue)
        }
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 300
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
}
