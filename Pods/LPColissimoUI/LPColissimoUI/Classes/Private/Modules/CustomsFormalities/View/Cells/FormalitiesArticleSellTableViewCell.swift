//
//  FormalitiesArticleSellTableViewCell.swift
//  LPColissimoUI
//
//  Created by Yonael Tordjman on 05/12/2018.
//

import UIKit

protocol FormalitiesArticleSellTableViewCellDelegate: class {
    func deleteButtonDidTapped(cell: FormalitiesArticleSellTableViewCell)
    func originCountryDidTapped(cell: FormalitiesArticleSellTableViewCell)
    func tarifSHButtonDidTapped(cell: FormalitiesArticleSellTableViewCell)
    func keyboardDidClose(cell: FormalitiesArticleSellTableViewCell)
}

class FormalitiesArticleSellTableViewCell: UITableViewCell {

    @IBOutlet weak var chevronButton: UIButton!
    @IBOutlet weak var articleNumber: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var descriptionSeparator: UIView!
    @IBOutlet weak var descriptionError: UILabel!
    
    @IBOutlet weak var tarifSHLabel: UILabel!
    @IBOutlet weak var tarifSHTextField: UITextField!
    @IBOutlet weak var tarifSHSeparator: UIView!
    @IBOutlet weak var tarifSHError: UILabel!
    
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var weightTextField: UITextField!
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
    
    @IBOutlet weak var originCountryLabel: UILabel!
    @IBOutlet weak var originCountryTextField: UITextField!
    @IBOutlet weak var originCountrySeparator: UIView!
    @IBOutlet weak var originCountryError: UILabel!
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var tarifSHButton: UIButton!
    
    weak var delegate: FormalitiesArticleSellTableViewCellDelegate?
    var currentTextfield: UITextField?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    
    @IBAction func tarifSHButtonTapped(_ sender: Any) {
        self.delegate?.tarifSHButtonDidTapped(cell: self)
    }
    
    func setupCell(sellArticle: SellArticle, index: Int, check: Bool, weight: Bool, country: String, itemsNumber: Int) {
        
        self.tarifSHButton.setTitle("Consulter les formalités douanières", for: .normal)
        self.tarifSHButton.contentHorizontalAlignment = .left
        
        self.chevronButton.setImage(ColissimoHomeServices.loadImage(name: "select.png"), for: .normal)
        self.chevronButton.imageView?.contentMode = .scaleAspectFit
        if itemsNumber > 1 {
            self.deleteButton.isHidden = false
        } else {
            if index == 0 {
                self.deleteButton.isHidden = true
            } else {
                self.deleteButton.isHidden = false
            }
        }

        self.tarifSHLabel.text = "N° tarif SH*"
        self.originCountryLabel.text = "Pays d'origine de l'objet*"
        self.articleNumber.text = "Article \(index + 1)"
        self.descriptionLabel.text = "Description de l'objet*"
        self.weightLabel.text = "Poids unitaire (en kg)*"
        self.quantityLabel.text = "Quantité*"
        self.unitPriceLabel.text = "Valeur unitaire (€)*"
        
        self.descriptionTextField.delegate = self
        self.weightTextField.delegate = self
        self.quantityTextField.delegate = self
        self.unitPriceTextField.delegate = self
        self.tarifSHTextField.delegate = self
        
        if let description = sellArticle.description, !description.isEmpty {
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
            self.weightTextField.textColor = .red
            self.weightError.text = "Ajustez le poids"
        } else {
            if let weight = sellArticle.weight {
                self.weightTextField.textColor = .black
                self.weightTextField.text = "\(weight)"
                self.weightError.text = ""
            } else {
                self.weightTextField.text = ""
                if !check {
                    self.weightError.text = "Le champ Poids est obligatoire"
                    self.weightError.numberOfLines = 0
                }
            }
        }
        
        if let quantity = sellArticle.quantity {
            self.quantityTextField.text = "\(quantity)"
            self.quantityError.text = ""
        } else {
            self.quantityTextField.text = ""
            if !check {
                self.quantityError.text = "Le champ Quantité est obligatoire"
                self.quantityError.numberOfLines = 0
            }
        }
        
        if let unitValue = sellArticle.unitValue {
            self.unitPriceTextField.text = "\(unitValue)"
            self.unitPriceError.text = ""
        } else {
            self.unitPriceTextField.text = ""
            if !check {
                self.unitPriceError.text = "Le champ Valeur Unitaire est obligatoire"
                self.unitPriceError.numberOfLines = 0
            }
        }
        
        if let tarifSH = sellArticle.tarifSH {
            if self.tarifSHTextField.text?.count != 6 && self.tarifSHTextField.text?.count != 8 &&
                self.tarifSHTextField.text?.count != 10 {
                self.tarifSHTextField.text = "\(tarifSH)"
                self.tarifSHError.text = "Le n° tarifaire doit être composé de 6, 8 ou 10 chiffres"
                self.tarifSHError.numberOfLines = 0
            } else {
                self.tarifSHTextField.text = "\(tarifSH)"
                self.tarifSHError.text = ""
            }
        } else {
            self.tarifSHTextField.text = ""
            if !check {
                self.tarifSHError.text = "Le n° tarifaire doit être composé de 6, 8 ou 10 chiffres"
                self.tarifSHError.numberOfLines = 0
            }
        }
        
        if let originCountry = sellArticle.originCountry {
            self.originCountryTextField.text = originCountry.name
            self.originCountryError.text = ""
        } else {
            self.originCountryTextField.text = "\(country)"
            if !check {
                self.originCountryError.text = "Le champ Pays est obligatoire"
                self.originCountryError.numberOfLines = 0
            }
        }
        
        self.tarifSHTextField.keyboardType = .decimalPad
        self.quantityTextField.keyboardType = .decimalPad
        self.unitPriceTextField.keyboardType = .decimalPad
        self.weightTextField.keyboardType = .decimalPad
        
        self.addDoneButtonOnKeyboard(textfield: self.tarifSHTextField)
        self.addDoneButtonOnKeyboard(textfield: self.quantityTextField)
        self.addDoneButtonOnKeyboard(textfield: self.unitPriceTextField)
        self.addDoneButtonOnKeyboard(textfield: self.weightTextField)
    }
    
    @IBAction func originCountryTapped(_ sender: Any) {
        self.delegate?.originCountryDidTapped(cell: self)
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

extension FormalitiesArticleSellTableViewCell: UITextFieldDelegate {
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
        case self.tarifSHTextField:
            let maxLength = 10
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        case self.weightTextField:
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
