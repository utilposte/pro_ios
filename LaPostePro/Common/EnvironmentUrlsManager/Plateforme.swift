//
//  Plateforme.swift
//  laposte
//
//  Created by ORIEUX Bastien on 30/7/18.
//  Copyright © 2018 laposte. All rights reserved.
//

import UIKit

class Plateforme: NSObject {
    
    
    private let kPART                   = ""
    private let kBASE                   = "BASE"
    private let kCCU                    = "CCU"
    private let kCCUV2                  = "CCUV2"
    private let kBoutique               = "Boutique"
    private let kEWP                    = "EWP"
    private let kCCMU                   = "CCMU"
    private let kMASCADIA               = "MASCADIA"
    private let kCGU                    = "CGU"
    private let kPDFLR                  = "PDFLR"
    private let kAccengage_Partner_ID   = "Accengage Partner ID"
    private let kAccengage_Private_Key  = "Accengage Private Key"
    private let kAdjust                 = "Adjust"
    private let kATTAG_Site_ID          = "ATTAG Site ID"
    private let kPayPal                 = "PayPal"
    
    
    var appName : String?
    var base : String?
    var ccu : String?
    var ccuv2 : String?
    var boutique : String?
    var ewp : String?
    var ccmu : String?
    var sercadia : String?
    var cgu : String?
    var pdfLR : String?
    var accengagePartnerId : String?
    var accengagePrivateKey : String?
    var adjust : String?
    var ATSiteId : String?
    var paypal : String?
    func toString(){
        Logger.shared.debug("appName : \(self.appName ?? "-")\nbase:\(self.base ?? "-")\nccu:\(self.ccu ?? "-")\nccuv2:\(self.ccuv2 ?? "-")\nboutique:\(self.boutique ?? "-")\nccmu:\(self.ccmu ?? "-")\npaypal:\(String(describing: self.paypal))")
    }
    init(dic : NSDictionary) {
        appName = "PRO"
        base = dic[kBASE] as? String ?? ""
        ccu = dic[kCCU] as? String ?? ""
        ccuv2 = dic[kCCUV2] as? String ?? ""
        boutique = dic[kBoutique] as? String ?? ""
        ewp = dic[kEWP] as? String ?? ""
        ccmu = dic[kCCMU] as? String ?? ""
        sercadia = dic[kMASCADIA] as? String ?? ""
        cgu = dic[kCGU] as? String ?? ""
        pdfLR = dic[kPDFLR] as? String ?? ""
        accengagePartnerId = dic[kAccengage_Partner_ID] as? String ?? ""
        accengagePrivateKey = dic[kAccengage_Private_Key] as? String ?? ""
        adjust = dic[kAdjust] as? String ?? ""
        ATSiteId = dic[kATTAG_Site_ID] as? String ?? ""
        paypal = dic[kPayPal] as? String ?? ""
    }
    
    func getDic() -> NSDictionary {
        var result = [String : String]() //NSDictionary()
        result[kBASE] = base
        result[kCCU] = ccu
        result[kCCUV2] = ccuv2
        result[kBoutique] = boutique
        result[kEWP] = ewp
        result[kCCMU] = ccmu
        result[kMASCADIA] = sercadia
        result[kCGU] = cgu
        result[kPDFLR] = pdfLR
        result[kAccengage_Partner_ID] = accengagePartnerId
        result[kAccengage_Private_Key] = accengagePrivateKey
        result[kAdjust] = adjust
        result[kATTAG_Site_ID] = ATSiteId
        result[kPayPal] = paypal
        return result as NSDictionary
    }
    
}
