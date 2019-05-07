//
//  CustomInputView.swift
//  LPColissimoUI
//
//  Created by LaPoste on 05/11/2018.
//  Copyright © 2018 LaPoste. All rights reserved.
//

import UIKit
enum RoundDirection{
    case left
    case right
    case none
}

@IBDesignable class CustomInputView: UIView {
    var contentView:UIView?
    var onDidBeginEditing : (Int)->Void = {(Int)-> Void in}
    let  nibName:String = "CustomInputView"
    var isAactive : Bool = true{
        didSet{
            self.desactivate()
        }
    }
    var roundDirection : RoundDirection =  .left {
        didSet{
            roundCorner(direction : roundDirection)
        }
    }
    
    var cutsomBorderColor : UIColor! = .lightGray{
        didSet{
            self.contentView?.layer.borderColor = cutsomBorderColor.cgColor
        }
    }
//
    @IBOutlet weak var textField: UITextField!
    
    func showError(){
       self.contentView?.layer.borderColor = UIColor.red.cgColor
    }
    
    func desactivate(){
        textField.isEnabled = false
    }
    func configure(){
        self.layer.backgroundColor  = UIColor.clear.cgColor
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
   override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.textField.becomeFirstResponder()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        xibSetup()
    }
    
    func xibSetup() {
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        view.autoresizingMask =
            [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        contentView = view
        
        configure()
    }
    
    func loadViewFromNib() -> UIView? {
//        guard let nibName = nibName else { return nil }
        let podBundle = Bundle(for: ColissimoManager.classForCoder())
        if let bundleURL = podBundle.url(forResource: "LPColissimoUI", withExtension: "bundle") {
            if let bundle = Bundle(url: bundleURL) {
                let nib = UINib(nibName: nibName, bundle: bundle)
                return nib.instantiate(
                    withOwner: self,
                    options: nil).first as? UIView
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        xibSetup()
        contentView?.prepareForInterfaceBuilder()
    }
    
    override func layoutSubviews() {
//            roundCorner()
    }
    
    func roundCorner(direction : RoundDirection = .none){

        self.contentView?.layer.masksToBounds = false

        self.contentView?.layer.borderWidth = 1.0
        self.contentView?.layer.borderColor = cutsomBorderColor.cgColor
        
        self.contentView?.backgroundColor =  UIColor.white
        self.contentView?.layer.cornerRadius = 5
       
        switch direction {
        case .left:
            if #available(iOS 11.0, *) {
                self.contentView?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
            } else {
                // Fallback on earlier versions
            }
        case .right:
            if #available(iOS 11.0, *) {
                self.contentView?.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            } else {
                // Fallback on earlier versions
            }
        case .none:
            self.contentView?.layer.cornerRadius = 0
            break
        }

    }
}

 // MARK: - UITextFieldDelegate
extension CustomInputView: UITextFieldDelegate{
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String)
        -> Bool
    {
        if string.count == 0 {
            return true
        }
        let currentText = textField.text ?? ""
        return currentText.count < 3
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.contentView?.layer.borderColor = UIColor.lpOrange.cgColor
        self.layoutSubviews()
        self.onDidBeginEditing(Int(textField.text!) ?? 0)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.contentView?.layer.borderColor = UIColor.lightGray.cgColor
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        print("👀  \(#function) 👀 \(String(describing: textField.text))");
        self.onDidBeginEditing(Int(textField.text!) ?? 0)
    }
    
    
    
}
