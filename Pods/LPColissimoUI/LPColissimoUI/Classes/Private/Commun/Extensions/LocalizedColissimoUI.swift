//
//  LocalizedColissimoUI.swift
//  LPColissimoUI
//
//  Created by Issam DAHECH on 19/10/2018.
//

import Foundation

extension NSObject {
    func LocalizedColissimoUI(key: String) -> String {
        let podBundle = Bundle(for: ColissimoManager.classForCoder())
        if let bundleURL = podBundle.url(forResource: "LPColissimoUI_Strings", withExtension: "bundle") {
            if let bundle = Bundle(url: bundleURL) {
                let s =  NSLocalizedString(key, tableName: "LocalizableColissimoUI", bundle: bundle, comment: "")
                return s
            }
        }
        return key
    }

}

