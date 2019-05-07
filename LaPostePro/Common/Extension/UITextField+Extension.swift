//
//  UITextField+Extension.swift
//  LaPostePro
//
//  Created by Lassad Tiss on 23/05/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

extension UITextField {
    func setLeftPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    override open var textInputMode: UITextInputMode? {

        let language_code = "fr"
        for keyboard in UITextInputMode.activeInputModes {

            if let language = keyboard.primaryLanguage {

                let locale = Locale.init(identifier: language);
                if locale.languageCode == language_code {
                    return keyboard;
                }
            }
        }
        return super.textInputMode;
    }
    
        
    
}
