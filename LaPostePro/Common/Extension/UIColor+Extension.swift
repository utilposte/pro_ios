//
//  UIColor+Extension.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 18/05/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

extension UIColor {

    static let lpPink: UIColor = UIColor(red: 255/255, green: 233/255, blue: 228/255, alpha: 1)
    static let lpGrey: UIColor = UIColor(red: 120/255, green: 120/255, blue: 130/255, alpha: 1)
    static let lpPurple: UIColor = UIColor(red: 146/255, green: 0/255, blue: 77/255, alpha: 1)
    static let lpYellow: UIColor = UIColor(red: 246/255, green: 204/255, blue: 79/255, alpha: 1)
    static let lpBackgroundGrey: UIColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
    static let lpDeepBlue: UIColor = UIColor(red: 5/255, green: 14/255, blue: 54/255, alpha: 1)
    static let lpGrayForInputTextBackround: UIColor = UIColor(red: 240/255, green: 241/255, blue: 242/255, alpha: 1)
    static let lpGrayShadow: UIColor = UIColor(red: 225/255, green: 227/255, blue: 229/255, alpha: 1)
    static let lpRedForUnavailableProduct = UIColor(red: 250/255, green: 73/255, blue: 73/255, alpha: 1)
    static let lpGreenForOpenOffice = UIColor(red: 139/255, green: 218/255, blue: 56/255, alpha: 1)

    convenience init(red: Int, green: Int, blue: Int) {

        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }

    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
