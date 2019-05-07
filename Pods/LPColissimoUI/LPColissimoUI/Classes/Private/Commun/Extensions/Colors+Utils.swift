//
//  Colors+Utils.swift
//  LPColissimoUI
//
//  Created by LaPoste on 11/09/2018.
//  Copyright © 2018 LaPoste. All rights reserved.
//

import UIKit

extension UIColor{
    public static var lpOrange: UIColor {
        return UIColor(red:238/255, green: 114/255, blue: 3/255, alpha: 1)
    }
     
    public static var lpGreen: UIColor {
        return UIColor(red:29/255, green: 179/255, blue: 132/255, alpha: 1)
    }
    
    public static var lpBlue: UIColor {
        return UIColor(red:0/255, green: 81/255, blue: 142/255, alpha: 1)
    }
    
    public static var lpGrey: UIColor {
        return UIColor(red:60/255, green: 60/255, blue: 59/255, alpha: 1)
    }
    
    public static var lpGradientRed: UIColor {
        return UIColor(red:236/255, green: 102/255, blue: 8/255, alpha: 1)
    }
    
    public static var lpGradientYellow: UIColor {
        return UIColor(red:251/255, green: 186/255, blue: 7/255, alpha: 1)
    }
    
    public static var lpTextGrey: UIColor {
        return UIColor(red: 104/255, green: 104/255, blue: 104/255, alpha: 1)
    }
    
    public static var lpBlueButton: UIColor {
        return UIColor(red: 0/255, green: 81/255, blue: 142/255, alpha: 1)
    }

    convenience init(hex: String) {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        var rgb:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgb)
        
        self.init(
            red: Int((rgb >> 16) & 0xFF),
            green: Int((rgb >> 8) & 0xFF),
            blue: Int(rgb & 0xFF)
        )
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    

  
}
