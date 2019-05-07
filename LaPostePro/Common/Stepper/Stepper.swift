//
//  Stepper.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 11/05/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

enum QuantityHandler {
    case minus
    case plus
    case keyboard
}

protocol StepperDelegate: class {
    func quantityChange(quantity: String, quantityHandler: QuantityHandler)
    func stepperTextFieldShouldReturn()
    func stepperTextFieldBegginEditing()
}

class Stepper: UIView {

    // MARK: IBOutlet
    @IBOutlet weak private var minusButton: UIButton!
    @IBOutlet weak private var plusButton: UIButton!
    @IBOutlet weak var quantityTextField: UITextField!
    private var tmpLastValue = 1

    // MARK: Properties
    weak var delegate: StepperDelegate?

    //create timer for multipe tap
    var timer: Timer?
    
    var lastValue = 1

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupNib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupNib()
    }

    private func loadNibFromView() -> UIView {
        let nib = UINib(nibName: "Stepper", bundle: nil)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }

    private func setupNib() {
        let view = self.loadNibFromView()
        view.borderColor = UIColor.lpGrayShadow
        view.borderWidth = 1
        view.frame = bounds
        self.quantityTextField.delegate = self
        self.quantityTextField.keyboardType = .numberPad
        self.quantityTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        addToolBar()
        view.layer.cornerRadius = 5.0
        view.clipsToBounds = true
        self.addSubview(view)
    }

    @objc private func cancelButtonClicked() {
        self.quantityTextField.resignFirstResponder()
        self.quantityTextField.text = String(tmpLastValue)
    }

    @IBAction private func minusButtonTapped(_ sender: Any) {
        var integerValue = 1
        if (quantityTextField.text?.isEmpty)! {
            self.quantityTextField.text = "\(1)"
            integerValue = 1
            validateNextQuantity(quantity: 1)
        } else {
            if let quantityIntValue = Int(self.quantityTextField.text!) {
                self.quantityTextField.text = "\(quantityIntValue - 1)"
                validateNextQuantity(quantity: quantityIntValue - 1)
                integerValue = quantityIntValue - 1
            } else {
                self.quantityTextField.text = "\(1)"
                integerValue = 1
                validateNextQuantity(quantity: 1)
            }
        }
         let userInfo = ["handler": QuantityHandler.minus,
                         "quantity": integerValue] as [String: Any]
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(callDelegateAfterTimer), userInfo: userInfo, repeats: false)
        } else {
            timer?.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(callDelegateAfterTimer), userInfo: userInfo, repeats: false)
        }
    }

    @IBAction private func plusButtonTapped(_ sender: Any) {
        var integerValue = 1
        if (quantityTextField.text?.isEmpty)! {
            self.quantityTextField.text = "\(1)"
            integerValue = 1
            validateNextQuantity(quantity: 1)
        } else {
            if let quantityIntValue = Int(self.quantityTextField.text!) {
                self.quantityTextField.text = "\(quantityIntValue + 1)"
                validateNextQuantity(quantity: quantityIntValue + 1)
                integerValue = quantityIntValue + 1
            } else {
                self.quantityTextField.text = "\(1)"
                integerValue = 1
                validateNextQuantity(quantity: 1)
            }
        }
        let userInfo = ["handler": QuantityHandler.plus,
                        "quantity": integerValue] as [String: Any]
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(callDelegateAfterTimer), userInfo: userInfo, repeats: false)
        } else {
            timer?.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(callDelegateAfterTimer), userInfo: userInfo, repeats: false)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.quantityTextField.endEditing(true)
    }

    fileprivate func validateNextQuantity(quantity: Int) {
        if (quantity + 1) > 999 {
            plusButton.isUserInteractionEnabled = false
            plusButton.alpha = 0.7
        } else {
            plusButton.isUserInteractionEnabled = true
            plusButton.alpha = 1
        }
        if (quantity - 1) == 0 {
            minusButton.isUserInteractionEnabled = false
            minusButton.alpha = 0.5
        } else {
            minusButton.isUserInteractionEnabled = true
            minusButton.alpha = 1
        }
    }

    @objc fileprivate func callDelegateAfterTimer(timer: Timer) {
        let userInfo = timer.userInfo as! [String: AnyObject]
        let handler = userInfo["handler"] as! QuantityHandler
        let quantity = userInfo["quantity"] as! Int
        switch handler {
        case .minus:
            delegate?.quantityChange(quantity: "\(quantity)", quantityHandler: .minus)
        case .plus:
            delegate?.quantityChange(quantity: "\(quantity)", quantityHandler: .plus)
        case .keyboard:
            delegate?.quantityChange(quantity: "\(quantity)", quantityHandler: .keyboard)
        }
        self.timer = nil
    }

    private func addToolBar() {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.lpDeepBlue
        let doneButton = UIBarButtonItem(title: "Valider", style: UIBarButtonItemStyle.done, target: self, action: #selector(textFieldShouldReturn(_:)))
        let cancelButton = UIBarButtonItem(title: "Annuler", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelButtonClicked))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()

        quantityTextField.inputAccessoryView = toolBar
    }

    internal func setQuantity(quantity: Int) {
        self.quantityTextField.text = String(quantity)
        validateNextQuantity(quantity: quantity)
    }
    internal func disableStepper() {
        self.alpha = 0.5
        self.minusButton.isEnabled = false
        self.plusButton.isEnabled = false
        self.quantityTextField.isEnabled = false
    }

    internal func getQuantity() -> String {
        return self.quantityTextField.text!
    }
}

extension Stepper: UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let text = textField.text, let integerValue = Int(text) {
            tmpLastValue = integerValue
        }
        if delegate != nil {
            delegate?.stepperTextFieldBegginEditing()
        }
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.text?.isEmpty)! {
            textField.text = String(tmpLastValue)
        }
    }

    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if delegate != nil {
            if (quantityTextField.text?.isEmpty)! {
                quantityTextField.text = "1"
                quantityTextField.resignFirstResponder()
                return false
            }
            if let text = quantityTextField.text, let integerValue = Int(text) {
                validateNextQuantity(quantity: integerValue)
                delegate?.quantityChange(quantity: text, quantityHandler: .keyboard)
                quantityTextField.resignFirstResponder()
            }
            return true
        }
        return false
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text, let integerValue = Int(text) else {
            return
        }
        validateNextQuantity(quantity: integerValue)
    }
    //max Length
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {

        let maxLength = 3
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        if newString == "0" {
            return false
        } else {
            return newString.length <= maxLength
        }
    }
}
