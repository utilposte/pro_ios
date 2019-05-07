//
//  EnvironmentUrlsManager.swift
//  laposte
//
//  Created by ORIEUX Bastien on 30/7/18.
//  Copyright © 2018 laposte. All rights reserved.
//

import UIKit
import LPSharedMCM

@objc class EnvironmentUrlsManager: NSObject ,MCMManagerDelegate{
    
    
    
    static let sharedManager = EnvironmentUrlsManager()
    
    private var plateforme : Plateforme?
    private let bundlGroup = "group.laposteapp.pro"
    var selectedPlateforme : String = "PROD"
    var deviceToken : String = ""
    lazy var loaderManager = LoaderViewManager()
    //    func setDevice
    func setMCMDelegate() {
//        let  environmentURLs = EnvironmentURLs.sharedInstance()
        MCMManager.sharedInstance().delegate = self
        getPlateforms()
        #if DEBUG
        
        Logger.shared.debug("******* DEV MODE *******")
        let sharedUserDefaults = UserDefaults.init(suiteName: bundlGroup)
        if let tmpDictionary = sharedUserDefaults?.object(forKey: "envirenementUrl") as? NSDictionary {
            plateforme = Plateforme(dic: tmpDictionary)
        }
        if let selectedPlateforme =  sharedUserDefaults?.string(forKey: "slectedPlateform") {
            Logger.shared.debug("*******  Selected Plateforme: \(selectedPlateforme) *******")
            self.selectedPlateforme = selectedPlateforme
        }
        
        #else
        Logger.shared.info("******* PROD *******")
        #endif
        self.plateforme?.toString()
    }
    
    func getPayPalProdEnvironment() -> String {
        return "AUhm4xrEAu7ESWzZDBtXjK_UCZGCNXY5eBAHmMDTaTInnvqFLHKDCVBUp-qQOjawWmcNIM8XcdUL8Fnq"
    }
    
    func getPayPalDevEnvironment() -> String {
        return plateforme?.paypal ?? "AbUbVRyugq0BydGK1BtfA8-WKKXflYIJ9KmqKbC9XVy_grdtOhEnPEHjpgaNlrPtNGhouw3jh0uoCNRU"
    }
    
    func showHideLoader(_ show: Bool) {
        if show == true {
            loaderManager.showLoderView()
        } else {
            loaderManager.hideLoaderView()
        }
    }
    
    func getATTagSiteId() -> String {
        return plateforme?.ATSiteId ?? "596913"
    }
    
    func getAdjustEnvironment() -> String {
        return plateforme?.adjust ?? "production"
    }
    
    func getAccengagePatnerId() -> String{
        return plateforme?.accengagePartnerId ?? "laposte929c860468fcd69"
    }
    
    func getAccengagePrivateKey() -> String{
        return plateforme?.accengagePrivateKey ?? "8705816e594de414644b917d3d5a516bf26f63df"
    }

    private func getPlateforms() {
        var plateform_file = "Plateformes-Prod"
        var plateform_target = "PROD"
        #if DEBUG
        plateform_file = "Plateformes-Dev"
        plateform_target = "RCT"
        #endif
        if let path = Bundle.main.path(forResource: plateform_file, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                var tmpDictionary = [String : String]()
                if let jsonResult = jsonResult as? Dictionary<String, AnyObject> {
                    let plateformes = jsonResult["Plateforme"] as? Dictionary<String, Any>
                    if let plateformesKeys = plateformes?.keys {
                        for key in plateformesKeys {
                            if let value = plateformes?[key] as? Dictionary<String, Any>  {
                                tmpDictionary[key] = value[plateform_target] as? String
                            }
                        }
                    }
                    
                    let parteners = jsonResult["Partner"] as? Dictionary<String, Any>
                    if let partenersKeys = parteners?.keys {
                        for key in partenersKeys {
                            if let value = parteners?[key] as? Dictionary<String, Any>  {
                                tmpDictionary[key] = value[plateform_target] as? String
                            }
                        }
                    }
                    plateforme = Plateforme(dic: tmpDictionary as NSDictionary)
                }
            }
            catch {
                Logger.shared.debug("DEBUG ERROR *********")
            }
        }
    }

    //MARK: - MCMManagerDelegate
    func getHybrisServiceHost() -> String {
        return plateforme?.boutique ?? "api.boutique.laposte.multimediabs.com"
    }
    
    func getSercadiaServiceHost() -> String {
        return plateforme?.sercadia ?? "https://www.serca.laposte.fr"
    }
    
    func getAppHeaderName() -> String? {
        return "PRO"
    }
}


