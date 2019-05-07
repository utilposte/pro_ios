//
//  UIImage+Bundle.swift
//  LPColissimoUI
//
//  Created by Issam DAHECH on 18/10/2018.
//

import UIKit


public extension UIImage {
    public class func loadImage(name: String) -> UIImage? {
        let podBundle = Bundle(for: ColissimoHomeServices.classForCoder())
        if let bundleURL = podBundle.url(forResource: "LPColissimoUI_Images", withExtension: "bundle") {
            let bundle = Bundle(url: bundleURL)
            return UIImage(named: name, in: bundle, compatibleWith: nil)
        }
        return nil
    }
}
