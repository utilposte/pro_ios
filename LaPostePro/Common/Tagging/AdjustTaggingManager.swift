//
//  AdjustTaggingManager.swift
//  LaPostePro
//
//  Created by Lassad Tiss on 19/09/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import Adjust

class AdjustTaggingManager: NSObject {

    static let sharedManager = AdjustTaggingManager()
    
    //static let kAdjustAppToken      = "ww4x5o28s7pc"
    
    static let kLaunchAppToken      = "by2m5r​"
    static let kOrderToken          = "ciukqr"
    static let kAddToCartToken      = "6y2w1x"
    static let kInscriptionToken    = "v91l2k"
    static let kDesinstallation     = "td8rvf"
    
    private static var appId : String?
    
    class func initSharedInstanceWith(appId:String){
        AdjustTaggingManager.appId = appId
    }
    
    private override init() {
        let appId = AdjustTaggingManager.appId
        guard appId != nil else {
            fatalError("Error - you must call setup before accessing MySingleton.shared")
        }
    }
    
    func applicationDidFinishLaunchingWith(token:String) {
        let appToken = AdjustTaggingManager.appId
        //let environment = EnvironmentUrlsManager.sharedManager.getAdjustEnvironment()
        let adjustConfig = ADJConfig.init(appToken: appToken!, environment: "production")
        adjustConfig?.logLevel = ADJLogLevelVerbose
        Adjust.appDidLaunch(adjustConfig)
        let event = ADJEvent.init(eventToken: token)
        Adjust.trackEvent(event)
    }
    
    func trackEventToken(_ token : String, price : Double?) {
        let event = ADJEvent.init(eventToken: token)
        if let revenu = price {
            event?.setRevenue(revenu, currency: "EUR")
        }
        Adjust.trackEvent(event)
    }
    
    func trackEventToken(_ token : String) {
        trackEventToken(token, price: nil)
    }
    
}
