//
//  AdvancedDialogTableViewCell.swift
//  LPColissimoUI
//
//  Created by Yonael Tordjman on 21/11/2018.
//

import UIKit

protocol AdvancedDialogTableViewCellDelegate: class {
    func switchDidChange(cell: AdvancedDialogTableViewCell)
    func thirdButtonTapped()
    func thirdTextFieldDidEditing(value: String, cell:AdvancedDialogTableViewCell)
    func thirdTextFieldDidChangeErrorStatus(value: String, cell:AdvancedDialogTableViewCell)
}

class AdvancedDialogTableViewCell: UITableViewCell {
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var arrowView: UIView!
    @IBOutlet weak var arrowImage: UIImageView!
    
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var firstLabel: UILabel!
    
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var secondSwitch: UISwitch!
    
    @IBOutlet weak var thirdView: UIView!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var thirdButton: UIButton!
    @IBOutlet weak var thirdTextField: UITextField!
    @IBOutlet weak var errorWeightLabel: UILabel!
    
    weak var delegate: AdvancedDialogTableViewCellDelegate?
    var priceError: InsuranceError = .none
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.secondSwitch.onTintColor = .lpOrange
    }
    
    func setupCell(initialPrice: Int, price: Int, isOn: Bool, tarif: String) {
        self.arrowImage.image = ColissimoHomeServices.loadImage(name:"triangle.png")
        self.thirdTextField.keyboardType = .numberPad
        self.firstLabel.text = "Ce mode de livraison inclut une indemnisation intégrée de \(initialPrice) €"
        
        self.secondLabel.text = "Je veux une indemnisation supérieure à \(initialPrice) €"
        self.thirdLabel.text = ""
        
        let attrs: [NSAttributedStringKey : Any] = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 12),
                                                    NSAttributedStringKey.foregroundColor : UIColor.white,
                                                    NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue]
        
        let attributeString = NSMutableAttributedString(string: "Voir tous les tarifs",
                                                        attributes: attrs)
        self.thirdButton.setAttributedTitle(attributeString, for: .normal)
        
        self.thirdButton.setTitle("Voir tous les tarifs", for: .normal)
        self.thirdButton.contentHorizontalAlignment = .left
        
        if initialPrice != price {
            self.thirdTextField.text = "\(price)"            
        } else {
            self.thirdTextField.text = "\(price + 1)"
        }
        
        self.errorWeightLabel.text = priceError.description
        self.errorWeightLabel.textColor = .lpOrange
        
        self.thirdTextField.contentVerticalAlignment = .center
        self.thirdTextField.textAlignment = .center
        self.thirdTextField.delegate = self
        
        self.secondView.clipsToBounds = true
        
        self.stackView.clipsToBounds = true
        self.stackView.layer.cornerRadius = 10
        
        self.thirdTextField.layer.masksToBounds = false
        self.thirdTextField.layer.shadowRadius = 2.0
        self.thirdTextField.layer.shadowColor = UIColor.gray.cgColor
        self.thirdTextField.layer.shadowOffset = CGSize.init(width: 0.7, height: 0.5)
        self.thirdTextField.layer.shadowOpacity = 0.5
        self.thirdTextField.layer.cornerRadius = 5
        self.thirdTextField.layer.borderColor = UIColor.white.cgColor
        
        self.firstView.roundCorners(corners: [.topLeft, .topRight], radius: 10)
        self.thirdLabel.text = tarif
        
        self.secondSwitch.isOn = isOn
        
        if isOn {
            self.thirdView.isHidden = false
            self.thirdView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10)
            self.secondView.roundCorners(corners: [.bottomRight, .bottomLeft], radius: 0)
        } else {
            self.thirdView.isHidden = true
            self.thirdView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 0)
            self.secondView.roundCorners(corners: [.bottomRight, .bottomLeft], radius: 10)
        }
    }
    
    @IBAction func thirdButtonTapped(_ sender: Any) {
        self.delegate?.thirdButtonTapped()
    }
    
    @IBAction func switchDidTouch(_ sender: Any) {
        self.delegate?.switchDidChange(cell: self)
    }
}

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

extension AdvancedDialogTableViewCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let _value = self.thirdTextField.text {
            self.delegate?.thirdTextFieldDidEditing(value: _value, cell: self)
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let _value = self.thirdTextField.text {
            self.delegate?.thirdTextFieldDidEditing(value: _value, cell: self)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var maxLength = 4
        if textField.text?.first == "1" {
            maxLength = 4
        } else {
            maxLength = 3
        }
        
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        self.delegate?.thirdTextFieldDidChangeErrorStatus(value: newString as String, cell: self)
        return newString.length <= maxLength
    }
    
}
