//
//  Fonts+Utils.swift
//  LPColissimoUI
//
//  Created by LaPoste on 29/10/2018.
//

import UIKit

public final class Fonts {
    static func podFont(name: String, size: CGFloat) -> UIFont {
        
        //Why do extra work if its available.
        if let font = UIFont(name: name, size: size) {return font}
        
        let bundle = Bundle(for: Fonts.self) //get the current bundle
        let url = bundle.url(forResource: name, withExtension: "otf")! //get the bundle url
        let data = NSData(contentsOf: url)! //get the font data
        let provider = CGDataProvider(data: name as! CFData)! //convert the data into a provider
        let cgFont = CGFont(provider)! //convert provider to cgfont
        let fontName = cgFont.postScriptName as! String //crashes if can't get name
        CTFontManagerRegisterGraphicsFont(cgFont, nil) //Registers the font, like the plist
        return UIFont(name: fontName, size: size)!
    }
}

extension UIFont {
    static func registerFont(bundle: Bundle, fontName: String, fontExtension: String) -> Bool {
        guard let fontURL = bundle.url(forResource: fontName, withExtension: fontExtension) else {
            fatalError("Couldn't find font \(fontName)")
        }
        
        guard let fontDataProvider = CGDataProvider(url: fontURL as CFURL) else {
            fatalError("Couldn't load data from the font \(fontName)")
        }
        
        guard let font = CGFont(fontDataProvider) else {
            fatalError("Couldn't create font from data")
        }
        
        var error: Unmanaged<CFError>?
        let success = CTFontManagerRegisterGraphicsFont(font, &error)
        guard success else {
            print("Error registering font: maybe it was already registered.")
            return false
        }
        
        return true
    }
}
