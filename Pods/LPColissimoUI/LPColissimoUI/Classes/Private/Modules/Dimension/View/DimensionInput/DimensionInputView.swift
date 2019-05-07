//
//  DimensionInputView.swift
//  LPColissimoUI
//
//  Created by LaPoste on 05/11/2018.
//  Copyright © 2018 LaPoste. All rights reserved.
//

import UIKit
struct DimensionValue {
    var largeur : Int = 0
    var longueur : Int = 0
    var hauteur : Int = 0
    func toString(){
        print("👀  \(#function) 👀 Largeur:\(largeur)|longueur\(longueur)|hauteur\(hauteur)");
    }
}
class DimensionInputView: UIView {
    var contentView:UIView?
    var onDidBeginEditing : (DimensionValue)->Void = {(DimensionValue)-> Void in}
    let  nibName:String = "DimensionInputView"
    var dimensionValue : DimensionValue = DimensionValue()
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet var inputViews: [CustomInputView]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        xibSetup()
    }
    
    func configure(){
        self.layer.backgroundColor  = UIColor.clear.cgColor
        self.contentView?.backgroundColor =  UIColor.white
        errorLabel.isHidden = true
        roundCorner()
        setupAction()
    }
    
    func validateInput()->Bool{
        var validCount = 0
        if (self.inputViews[0].textField.text?.isEmpty)! {
            validCount += 1
            self.inputViews[0].showError()
        }
        if (self.inputViews[1].textField.text?.isEmpty)! {
           validCount += 1
            self.inputViews[1].showError()
        }
        if (self.inputViews[2].textField.text?.isEmpty)! {
            validCount += 1
            self.inputViews[2].showError()
        }
        
        return validCount != 0
    }
    
    func setup(value : DimensionValue){
        dimensionValue = value
        self.inputViews[0].textField.text = "\(value.longueur)"
        self.inputViews[1].textField.text = "\(value.largeur)"
        self.inputViews[2].textField.text = "\(value.hauteur)"
    }
    
    func reinit(){
        self.inputViews[1].textField.text = ""
        self.inputViews[2].textField.text = ""
        self.inputViews[0].textField.text = ""
        self.inputViews[0].textField.becomeFirstResponder()
    }
    
    func hideError(){
        errorLabel.isHidden = true
        self.contentView?.layoutIfNeeded()
        self.contentView?.layoutSubviews()
    }
    func showError(){
        errorLabel.isHidden = false
        self.contentView?.layoutIfNeeded()
        self.contentView?.layoutSubviews()
    }
    func desactivate(){
        self.inputViews[0].isAactive = false
        self.inputViews[1].isAactive = false
        self.inputViews[2].isAactive = false
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
//        roundCorner()
    }
    
    func roundCorner(){
        
        self.contentView?.layer.masksToBounds = false
        self.contentView?.layer.cornerRadius = 5
        
        self.inputViews[0].roundDirection = .left
        self.inputViews[1].roundDirection = .none
        self.inputViews[2].roundDirection = .right
        
        
    }
    
    func setupAction(){
        self.inputViews[0].onDidBeginEditing={ (d) in
            self.dimensionValue.longueur = d
            self.onDidBeginEditing(self.dimensionValue)
        }
        self.inputViews[1].onDidBeginEditing={ (d) in
            self.dimensionValue.largeur = d
            self.onDidBeginEditing(self.dimensionValue)
        }
        self.inputViews[2].onDidBeginEditing={ (d) in
            self.dimensionValue.hauteur = d
            self.onDidBeginEditing(self.dimensionValue)
        }
    }
}
