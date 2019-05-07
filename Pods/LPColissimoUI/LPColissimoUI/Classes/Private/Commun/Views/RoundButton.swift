//
//  RoundButton.swift
//  LPColissimoUI
//
//  Created by Khaled El Abed on 25/10/2018.
//  Copyright © 2018 Khaled El Abed. All rights reserved.
//

import UIKit

@IBDesignable class RoundButton: UIButton {
    @IBInspectable var customColor : UIColor = UIColor.lpGreen {
        didSet{
//            self.tintColor = customColor
            self.backgroundColor =  customColor
        }
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    override func prepareForInterfaceBuilder() {
        sharedInit()
    }
    
    func sharedInit() {
        layer.cornerRadius = self.frame.size.height/2
        customColor = UIColor.lpGreen
       // titleEdgeInsets = UIEdgeInsetsMake(10,10,10,10)
    }
    
    func refreshCorners(value: CGFloat) {
        layer.cornerRadius = value
    }
    
}
