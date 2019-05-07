//
//  ATInternetTagManager.swift
//  LaPostePro
//
//  Created by Lassad Tiss on 12/09/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import ATInternet_iOS_ObjC_SDK

class ATInternetTaggingManager: NSObject {

    @objc static let sharedManager = ATInternetTaggingManager()
    var tracker = ATInternet.sharedInstance().defaultTracker
    
    // Configuration
    
    private func baseTrackingConfig() {
        
        let tagLogSubDomain = TaggingData.kATTagSubDomain
        
        let tagSiteID = ColissimoManager.sharedManager.tagSiteID
        
        let configuration : [AnyHashable : Any] = [
            "log":tagLogSubDomain,
            "logSSL":"logs",
            "domain":"xiti.com",
            "pixelPath":"/hit.xiti",
            "site":tagSiteID ?? "",
            "secure":"false",
            "identifier":"uuid",
            "plugins":"tvtracking",
            "enableBackgroundTask":"true",
            "storage":"required",
            "hashUserId":"false",
            "persistIdentifiedVisitor":"true",
            "tvtURL": "",
            "tvtVisitDuration":"10",
            "campaignLastPersistence": "false",
            "campaignLifetime": "30",
            "sessionBackgroundDuration": "100"]
        
        self.tracker = ATInternet.sharedInstance().tracker(withName: "LaposteProConfiguredTracker", configuration: configuration)
        
        if ColissimoManager.sharedManager.isValidToken {
            _ = self.tracker?.identifiedVisitor.setWithTextId(ColissimoManager.sharedManager.displayUid)
            _ = self.tracker?.customVars.add(withId: 1, value: "1", type: .app)
        } else {
            _ = self.tracker?.customVars.add(withId: 1, value: "0", type: .app)
        }
        
        
    }
    
    // Screen
    
    private func buildScreenWith(pageName : String, chapter1 : String?, chapter2 : String?, chapter3 : String?, level2 : Int32?)  -> ATScreen {
        let myScreen : ATScreen = (self.tracker?.screens.add(withName: pageName))!
        if (chapter1 != nil) {
            myScreen.chapter1 = chapter1
        }
        if (chapter2 != nil) {
            myScreen.chapter2 = chapter2
        }
        if (chapter3 != nil) {
            myScreen.chapter2 = chapter3
        }
        if (level2 != nil) {
            myScreen.level2 = level2!
        }
        return myScreen
    }
    
    func sendTrackPage(pageName : String, chapter1 : String?, chapter2 : String?, chapter3 : String?, level2 : Int32?) {
        self.baseTrackingConfig()
        let screen = buildScreenWith(pageName: pageName, chapter1: chapter1, chapter2: chapter2, chapter3: chapter3, level2: level2)
        print("******** ATInternetTaggingManager :: sendTrackPage :: \(pageName) _ \(chapter1 ?? "") _ \(chapter2 ?? "") \(level2 ?? 0)")
        screen.sendView()
    }
    
    // Click
    
    private func buildClickWith(clickLibelle : String, pageName : String?, chapter1 : String?, chapter2 : String?, level2 : Int32?)  -> ATGesture {
        
        let myClick = self.tracker?.gestures.add(withName: clickLibelle, chapter1: chapter1, chapter2: chapter2, chapter3: pageName)
        
        if (chapter1 != nil) {
            myClick?.chapter1 = chapter1
        }
        if (chapter2 != nil) {
            myClick?.chapter2 = chapter2
        }
        if (pageName != nil) {
            myClick?.chapter3 = pageName
        }
        if (level2 != nil) {
            myClick?.level2 = level2!
        }
        return myClick!
    }
    
    func sendTrackClick(clickLibelle : String, pageName : String?, chapter1 : String?, chapter2 : String?, level2 : Int32?) {
        self.baseTrackingConfig()
        let click = self.buildClickWith(clickLibelle: clickLibelle, pageName: pageName, chapter1: chapter1, chapter2: chapter2, level2: level2)
        print("******** ATInternetTaggingManager :: sendTrackClick :: \(clickLibelle) _ \(pageName ?? "") _ \(chapter1 ?? "") _ \(chapter2 ?? "") \(level2 ?? 0)")
        click.sendTouch()
    }
    
}
