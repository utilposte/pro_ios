//
//  CTTextFieldCell.swift
//  laposte
//
//  Created by Issam DAHECH on 04/12/2017.
//  Copyright © 2017 laposte. All rights reserved.
//

import UIKit

class CTTextFieldCell: CTBaseTableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var errorLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var errorLabel: UILabel!
    let limitLength = 6
    
    override func configureCellStep(_ step: CTStep, firstStep: Int) {
        super.configureCellStep(step, firstStep: firstStep)
        addDoneButtonOnKeyboard()
        self.textField.delegate = self
        if step.name.contains("Poid") {
            dataLabel.text = "grammes"
            textField.placeholder = CTDataWrapper.sharedInstanse.getMaxWeightWithShippementType(shippementType: self.step1Value)
        } else if step.name == CTConstants.adValoremFilterName {
            dataLabel.text = "€"
            textField.placeholder = "Montant"
        }
        textField.text = step.value
        errorLabelHeightConstraint.constant = 0
        self.layoutIfNeeded()
    }

    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x:0, y:0, width:320, height:50))
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let font = UIFont(name: "DINPro-Bold", size: 17)
        let cancel : UIBarButtonItem = UIBarButtonItem(title: "Annuler", style: .done, target: self, action: #selector(CTTextFieldCell.cancelButtonAction))
        cancel.setTitleTextAttributes([NSAttributedStringKey.font: font!], for: .normal)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Valider", style: UIBarButtonItemStyle.done, target: self, action: #selector(CTTextFieldCell.doneButtonAction))
        done.setTitleTextAttributes([NSAttributedStringKey.font: font!], for: .normal)
        
        let items = NSMutableArray()
        items.add(cancel)
        items.add(flexSpace)
        items.add(done)
        
        doneToolbar.items = (items as! [UIBarButtonItem])
        doneToolbar.sizeToFit()
        
        self.textField.inputAccessoryView = doneToolbar
        self.textField.inputAccessoryView = doneToolbar
        
    }
    
    @objc func doneButtonAction() {
        self.currentStep.value = textField.text!
//        let isValid = self.validateValue(reloadTableViewIfNeeded: true)
//        if isValid {
//            hideErrorMessage()
//            if self.formDelegate != nil {
//                self.formDelegate.weightTextFieldEndEditing(step: self.currentStep)
//            }
//        }
        textField.resignFirstResponder()
    }
    
    @objc func cancelButtonAction() {
        self.endEditing(true)
    }
    
    func showErrorMessage(message: String) {
        errorLabel.text = message
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut], animations: {
            self.errorLabelHeightConstraint.constant = 17
            self.layoutIfNeeded()
        }, completion: nil)
        
    }
    
    func hideErrorMessage() {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut], animations: {
            self.errorLabelHeightConstraint.constant = 0
            self.layoutIfNeeded()
        }, completion: nil)
    }
    //delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= limitLength
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.currentStep.value = textField.text!
        let isValid = self.validateValue(reloadTableViewIfNeeded: true)
        if isValid {
            hideErrorMessage()
            if self.formDelegate != nil {
                self.formDelegate.weightTextFieldEndEditing(step: self.currentStep)
            }
        }
    }
    
    func validateValue(reloadTableViewIfNeeded : Bool) -> Bool {
        if currentStep.value == "" {
            if currentStep.name.contains("Poid") {
                showErrorMessage(message:"Veuillez saisir le poids de votre envoi")
            } else {
                showErrorMessage(message:"Ce champ est obligatoire.")
            }
            if self.formDelegate != nil && reloadTableViewIfNeeded {
                self.formDelegate.hideFilterAfterError(step: self.currentStep)
            }
            return false
        } else {
            if currentStep.name == CTConstants.adValoremFilterName {
                if Int64(currentStep.value)! < 200 {
                    showErrorMessage(message:"Le montant doit être supérieur à 200€")
                    if self.formDelegate != nil && reloadTableViewIfNeeded {
                        self.formDelegate.hideFilterAfterError(step: self.currentStep)
                    }
                    return false
                }
            } else if currentStep.name.contains("Poid") {
                if Int64(currentStep.value)! == 0 {
                    showErrorMessage(message: "Veuillez saisir une valeur supérieure à 0")
                    if self.formDelegate != nil && reloadTableViewIfNeeded {
                        self.formDelegate.hideFilterAfterError(step: self.currentStep)
                    }
                    return false
                }
                
                switch step1Value {
                case 1:
                    if Int64(currentStep.value)! > 30000 {
                        showErrorMessage(message: "Le poids maximum est de 30000g")
                        if self.formDelegate != nil && reloadTableViewIfNeeded {
                            self.formDelegate.hideFilterAfterError(step: self.currentStep)
                        }
                        return false
                    }
                    break
                case 2:
                    if Int64(currentStep.value)! > 3000 {
                        showErrorMessage(message: "Le poids maximum est de 3000g")
                        if self.formDelegate != nil && reloadTableViewIfNeeded {
                            self.formDelegate.hideFilterAfterError(step: self.currentStep)
                        }
                        return false
                    }
                    break
                case 3:
                    if Int64(currentStep.value)! > 30000 {
                        showErrorMessage(message: "Le poids maximum est de 30000g")
                        if self.formDelegate != nil && reloadTableViewIfNeeded {
                            self.formDelegate.hideFilterAfterError(step: self.currentStep)
                        }
                        return false
                    }
                    break
                default:
                    break
                }
                
            }
        }
        return true
    }
}

