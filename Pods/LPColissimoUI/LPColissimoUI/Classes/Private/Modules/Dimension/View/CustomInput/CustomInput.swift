//
//  CustomInput.swift
//  LPColissimoUI
//
//  Created by LaPoste on 05/11/2018.
//  Copyright © 2018 LaPoste. All rights reserved.
//

import UIKit

class UITextFieldPadding : UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setBorder()
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }

    
    func setBorder() {
        self.borderStyle = .roundedRect
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.masksToBounds = false
        self.layer.borderWidth = 2.0
        self.layer.borderColor =  UIColor.lpOrange.cgColor
    }
    
    
    
}
