//
//  FormalitiesArticleTableViewCell.swift
//  LPColissimoUI
//
//  Created by Yonael Tordjman on 04/12/2018.
//

import UIKit

protocol FormalitiesArticleTableViewCellDelegate: class {
    func deleteButtonDidTapped(cell: FormalitiesArticleTableViewCell)
    func keyboardDidClose(cell: FormalitiesArticleTableViewCell)
}

class FormalitiesArticleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var articleNumber: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var descriptionSeparator: UIView!
    @IBOutlet weak var descriptionError: UILabel!
    
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var weightTextfield: UITextField!
    @IBOutlet weak var weightSeparator: UIView!
    @IBOutlet weak var weightError: UILabel!
    
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var quantitySeparator: UIView!
    @IBOutlet weak var quantityError: UILabel!
    
    @IBOutlet weak var unitPriceLabel: UILabel!
    @IBOutlet weak var unitPriceTextField: UITextField!
    @IBOutlet weak var unitPriceSeparator: UIView!
    @IBOutlet weak var unitPriceError: UILabel!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    weak var delegate: FormalitiesArticleTableViewCellDelegate?
    var currentTextfield: UITextField?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func setupCell(article: Article, index: Int, check: Bool, weight: Bool, itemsNumber: Int) {
        if itemsNumber > 1 {
            self.deleteButton.isHidden = false
        } else {
            if index == 0 {
                self.deleteButton.isHidden = true
            } else {
                self.deleteButton.isHidden = false
            }
        }
        
        if let description = article.description, !description.isEmpty {
            self.descriptionTextField.text = "\(description)"
            self.descriptionError.text = ""
        } else {
            self.descriptionTextField.text = ""
            if !check {
                self.descriptionError.text = "Le champ Description est obligatoire"
                self.descriptionError.numberOfLines = 0
            }
        }
        
        if !weight {
            self.weightTextfield.textColor = .red
            self.weightError.text = "Ajustez le poids"
        } else {
            if let weight = article.weight {
                self.weightTextfield.textColor = .black
                self.weightTextfield.text = "\(weight)"
                self.weightError.text = ""
            } else {
                self.weightTextfield.text = ""
                if !check {
                    self.weightError.text = "Le champ Poids est obligatoire"
                    self.weightError.numberOfLines = 0
                }
            }
        }
        
        if let quantity = article.quantity {
            self.quantityTextField.text = "\(quantity)"
            self.quantityError.text = ""
        } else {
            self.quantityTextField.text = ""
            if !check {
                self.quantityError.text = "Le champ Quantité est obligatoire"
                self.quantityError.numberOfLines = 0
            }
        }
        
        if let unitValue = article.unitValue {
            self.unitPriceTextField.text = "\(unitValue)"
            self.unitPriceError.text = ""
        } else {
            self.unitPriceTextField.text = ""
            if !check {
                self.unitPriceError.text = "Le champ Valeur Unitaire est obligatoire"
                self.unitPriceError.numberOfLines = 0
            }
        }
        
        self.articleNumber.text = "Article \(index + 1)"
        
        self.descriptionLabel.text = "Description de l'objet*"
        self.weightLabel.text = "Poids unitaire (en kg)*"
        self.quantityLabel.text = "Quantité*"
        self.unitPriceLabel.text = "Valeur unitaire (€)*"
        
        self.descriptionTextField.delegate = self
        self.weightTextfield.delegate = self
        self.quantityTextField.delegate = self
        self.unitPriceTextField.delegate = self
        
        self.descriptionTextField.keyboardType = .default
        self.weightTextfield.keyboardType = .decimalPad
        self.quantityTextField.keyboardType = .decimalPad
        self.unitPriceTextField.keyboardType = .decimalPad
        
        self.addDoneButtonOnKeyboard(textfield: self.weightTextfield)
        self.addDoneButtonOnKeyboard(textfield: self.quantityTextField)
        self.addDoneButtonOnKeyboard(textfield: self.unitPriceTextField)
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        self.delegate?.deleteButtonDidTapped(cell: self)
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
        if let textfield = self.currentTextfield {
            _ = textfield.delegate?.textFieldShouldReturn!(textfield)
        }
    }
    
}

extension FormalitiesArticleTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.delegate?.keyboardDidClose(cell: self)
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.currentTextfield = textField
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case self.descriptionTextField:
            let maxLength = 40
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        case self.weightTextfield:
            var maxLength = 2
            if (textField.text?.contains(Character(",")) == true || string == ",") || (textField.text?.contains(Character(".")) == true || string == ".") {
                maxLength = 5
            } else {
                maxLength = 2
            }
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        case self.quantityTextField:
            let maxLength = 2
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        case self.unitPriceTextField:
            var maxLength = 4
            if (textField.text?.contains(Character(",")) == true || string == ",") || (textField.text?.contains(Character(".")) == true || string == ".") {
                maxLength = 7
            } else {
                maxLength = 4
            }
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        default:
            return true
        }
    }
}
