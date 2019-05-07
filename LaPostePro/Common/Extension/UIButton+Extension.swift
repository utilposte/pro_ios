//
//  UIButton+Extension.swift
//  LaPostePro
//
//  Created by Issam DAHECH on 05/12/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

extension UIButton {
    func setActionDisabled() {
        self.backgroundColor = UIColor.lpGrayShadow
        self.setTitleColor(UIColor.lpGrey, for: .normal)
    }
    
    func setActionPrimary() {
        self.backgroundColor = UIColor.lpPurple
        self.setTitleColor(UIColor.white, for: .normal)
    }
    
    func setActionSecondary() {
        self.backgroundColor = UIColor.lpDeepBlue
        self.setTitleColor(UIColor.white, for: .normal)
    }
}
