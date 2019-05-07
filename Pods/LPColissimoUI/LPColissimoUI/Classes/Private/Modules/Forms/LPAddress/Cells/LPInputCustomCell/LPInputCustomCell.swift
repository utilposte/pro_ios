//
//  LPInputCustomCell.swift
//  laposte
//
//  Created by Sofien Azzouz on 10/01/2018.
//  Copyright © 2018 laposte. All rights reserved.
//

protocol LPInputCellDelegate: class {
    func inputTextFieldChanged(text: String, formType: FormKeys)
    func inputTextFieldReturnClicked(tag: Int)
    
}

class LPInputCustomCell: LPBaseCustomCell, UITextFieldDelegate {
    
    @IBOutlet weak var errorMsgLabel: UILabel!
    @IBOutlet weak var titleButton: UIButton!
    @IBOutlet weak var inputTextField: UITextField!
    
    @IBOutlet var separatorView: UIView!
    var themeColor: UIColor?
    var delegate: LPInputCellDelegate?
    var maxCount : Int?
    var isInternational: Bool = false
    override func interfaceInitialization() {
        self.errorMsgLabel.isHidden = true
    }
    
    func initCellWithData(fieldMsg: String?, titleMsg: String, isMandatory: Bool, formType: FormKeys, themeColor: UIColor, textFieldTag: Int) {
        let mandatoryMessage = "\(titleMsg+" *")"
        self.isMandatory = isMandatory
        let  title =  self.isMandatory ?  mandatoryMessage : titleMsg
        self.titleButton.setTitle(title, for: UIControlState.normal)
        
        self.inputTextField.text = fieldMsg?.uppercased()
        self.cellType = formType
        self.themeColor = themeColor
        
        self.inputTextField.tag = textFieldTag
        addDoneButtonOnKeyboard()
        switch formType {
        case .Locality:
            self.inputTextField.returnKeyType = UIReturnKeyType.done
            break
        case .Email:
            addDoneButtonOnKeyboard()
            self.inputTextField.keyboardType = UIKeyboardType.emailAddress
            
            break
        case .PostalCode:
            addDoneButtonOnKeyboard()
            if isInternational {
                self.inputTextField.keyboardType = UIKeyboardType.default
            } else {
                self.inputTextField.keyboardType = UIKeyboardType.decimalPad
            }
            
            
            break
        case .Tel:
            addDoneButtonOnKeyboard()
            self.inputTextField.keyboardType = UIKeyboardType.phonePad
            break
            
        default:
            self.inputTextField.keyboardType = UIKeyboardType.default
        }
    }
    
    override func cellHeight() -> CGFloat {
        return 111
    }
    
    override func showErrorMsg(errorMsg: String) {
        self.errorMsgLabel.isHidden = false
        self.errorMsgLabel.text = errorMsg
        print("******SHOW MESSAGE FOR\(String(describing: self.inputTextField.text))")
        
    }
    
    override func hideErrorMsg() {
//        print("******Hide MESSAGE FOR\(String(describing: self.inputTextField@objc .text))")
        self.errorMsgLabel.isHidden = true
        
    }
    
    // MARK: - Text Field Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        self.delegate?.inputTextFieldReturnClicked(tag: self.inputTextField.tag)
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.separatorView.backgroundColor = self.themeColor
        self.inputText = textField.text!
        if self.cellType! == FormKeys.Steet {
            self.delegate?.inputTextFieldChanged(text: self.inputText, formType: self.cellType!)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.delegate?.inputTextFieldChanged(text: textField.text!, formType: self.cellType!)
        self.inputText = textField.text!
        self.separatorView.backgroundColor = BACKGROUND_GREY_COLOR
        print("TextField did end editing method called\(self.inputText)")
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if cellType! == .Tel {
            guard let text = textField.text else { return true }
            let count = text.count + string.count - range.length
            return count <= 20
        }
        if cellType! == .PostalCode{
            if let maxCount  = maxCount{
                        guard let text = textField.text else { return true }
                        let count = text.count + string.count - range.length
                return count <= maxCount
            }
           
        }
         return true
        
    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        guard let text = textField.text else { return true }
//        let count = text.count + string.count - range.length
//        return count <= 4
//    }
    
    @IBAction func titleButtonClicked(_ sender: Any) {
        self.inputTextField.becomeFirstResponder()
    }
    
    // UI action
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x:0, y:0, width:320, height:50))
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let font = UIFont(name: "DINPro-Bold", size: 17)
        let cancel : UIBarButtonItem = UIBarButtonItem(title: "Annuler", style: .done, target: self, action: #selector(CTTextFieldCell.cancelButtonAction))
        //cancel.setTitleTextAttributes([NSAttributedStringKey.font: font!], for: .normal)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Valider", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.doneButtonAction))
//        done.setTitleTextAttributes([NSAttributedStringKey.font: font!], for: .normal)
        
        let items = NSMutableArray()
        items.add(cancel)
        items.add(flexSpace)
        items.add(done)
        
        doneToolbar.items = (items as! [UIBarButtonItem])
        doneToolbar.sizeToFit()
        
        self.inputTextField.inputAccessoryView = doneToolbar
        self.inputTextField.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        self.delegate?.inputTextFieldChanged(text: self.inputText, formType: self.cellType!)
        self.inputTextField.resignFirstResponder()
    }
    
    @objc func cancelButtonAction() {
        self.inputText = ""
        self.inputTextField.text = ""
        self.delegate?.inputTextFieldChanged(text: self.inputText, formType: self.cellType!)
        
        self.endEditing(true)
    }
    
    
    override func prepareForReuse() {
        self.inputTextField.keyboardType = UIKeyboardType.default
        self.hideErrorMsg()
    }
}


