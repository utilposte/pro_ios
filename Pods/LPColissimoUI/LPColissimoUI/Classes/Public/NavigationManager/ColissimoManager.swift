//
//  ColissimoManager.swift
//  LPColissimoUI
//
//  Created by Issam DAHECH on 17/10/2018.
//

import UIKit
import LPColissimo

@objc public class ColissimoManager: NSObject {
    
    var initData : DataContainer?
    
    public static let sharedManager = ColissimoManager()
        
    @objc class var swiftSharedInstance: ColissimoManager {
        struct Singleton {
            static let instance = ColissimoManager()
        }
        return Singleton.instance
    }
    
    // the sharedInstance class method can be reached from ObjC
   @objc public class func sharedInstance() -> ColissimoManager {
        return ColissimoManager.swiftSharedInstance
    }
    
    public var delegate: ColissimoManagerDelegate?
    public var departureCountries: [CLCountry] = []
    public var arrivalCountries: [CLCountry] = []
    
    public var selectedDeparture: CLCountry!
    public var selectedArrival: CLCountry!
    
    public var defaultArrivalCountry: String = ""
    public var defaultDepartureCountry: String = ""
    public var accessToken: String = "" {
        didSet{
            ColissimoAPIClient.sharedInstance.accessToken = accessToken
        }
    }
    
    // ATInternet
    public var tagSiteID: String = ""
    public var displayUid: String = ""
    public var isValidToken: Bool = false
    
    public var baseUrl : String = ""{
        didSet{
            ColissimoAPIClient.sharedInstance.baseUrl = baseUrl
            
        }
    }
    
    public func getColissimoRecap()-> UIViewController {
        
        let podBundle = Bundle(for: ColissimoManager.classForCoder())
        
        if let bundleURL = podBundle.url(forResource: "LPColissimoUI", withExtension: "bundle") {
            if let bundle = Bundle(url: bundleURL) {
                let storybord = UIStoryboard(name: "CLRecap", bundle: bundle)
                let vc = storybord.instantiateViewController(withIdentifier: "CLRecapViewController") as? CLRecapViewController
                return vc ?? UIViewController()
            }
            else {
                print("Could not load the bundle")
            }
        }
        else {
            print("Could not create a path to the bundle")
        }
        return UIViewController()
    }
    
    public func getMoreInfoWebView() -> UIViewController {
        let podBundle = Bundle(for: ColissimoManager.classForCoder())
        
        if let bundleURL = podBundle.url(forResource: "LPColissimoUI", withExtension: "bundle") {
            if let bundle = Bundle(url: bundleURL) {
                let storybord = UIStoryboard(name: "Web", bundle: bundle)
                let vc = storybord.instantiateViewController(withIdentifier: "CLWebViewControllerID") as? CLWebViewController
                return vc ?? UIViewController()
            }
            else {
                print("Could not load the bundle")
            }
        }
        else {
            print("Could not create a path to the bundle")
        }
        return UIViewController()
    }
    
    public func getColissimoFormalities()-> UIViewController {
        
        let podBundle = Bundle(for: ColissimoManager.classForCoder())        
        
        if let bundleURL = podBundle.url(forResource: "LPColissimoUI", withExtension: "bundle") {
            if let bundle = Bundle(url: bundleURL) {
                let storybord = UIStoryboard(name: "CustomsFormalities", bundle: bundle)
                let homeViewController = storybord.instantiateViewController(withIdentifier: "CustomFormalitiesViewController") as? CustomFormalitiesViewController
                return homeViewController ?? UIViewController()
            }
            else {
                print("Could not load the bundle")
            }
        }
        else {
            print("Could not create a path to the bundle")
        }
        return UIViewController()
    }
    
    @objc public func getSenderForm(isConnected : Bool)->UIViewController{
        
        let podBundle = Bundle(for: ColissimoManager.classForCoder())
        
        if let bundleURL = podBundle.url(forResource: "LPColissimoUI", withExtension: "bundle") {
            if let bundle = Bundle(url: bundleURL) {
                let storybord = UIStoryboard(name: "CLAddress", bundle: bundle)
                let homeViewController = storybord.instantiateViewController(withIdentifier: "CLSenderViewController") as! CLSenderViewController
                homeViewController.isConnected = isConnected
                return homeViewController 
            }
            else {
                print("Could not load the bundle")
            }
        }
        else {
            print("Could not create a path to the bundle")
        }
        return UIViewController()
    }
    
    public func getReceiverForm(isConnected : Bool)->UIViewController{
        
        let podBundle = Bundle(for: ColissimoManager.classForCoder())
        
        if let bundleURL = podBundle.url(forResource: "LPColissimoUI", withExtension: "bundle") {
            if let bundle = Bundle(url: bundleURL) {
                let storybord = UIStoryboard(name: "CLAddress", bundle: bundle)
                let homeViewController = storybord.instantiateViewController(withIdentifier: "CLReceiverViewController") as! CLReceiverViewController
                homeViewController.isConnected = isConnected
                return homeViewController
            }
            else {
                print("Could not load the bundle")
            }
        }
        else {
            print("Could not create a path to the bundle")
        }
        return UIViewController()
    }
    
    public func loadImg(name: String) -> UIImage {
        let podBundle = Bundle(for: ColissimoManager.classForCoder())
        if let bundleURL = podBundle.url(forResource: "LPColissimoUI_Images", withExtension: "bundle") {
            if let bundle = Bundle(url: bundleURL) {
                return UIImage(named: name, in: bundle, compatibleWith: nil) ?? UIImage()
            }
        }
        return UIImage()
    }
    
    @objc public func getGenericForm()-> UIViewController {
        
        let podBundle = Bundle(for: ColissimoManager.classForCoder())
        
        if let bundleURL = podBundle.url(forResource: "LPColissimoUI", withExtension: "bundle") {
            if let bundle = Bundle(url: bundleURL) {
                let storybord = UIStoryboard(name: "LPAddress", bundle: bundle)
                if let homeViewController = storybord.instantiateViewController(withIdentifier: "LPAddressViewController") as? LPAddressViewController {
                     return homeViewController
                }
                return  UIViewController()
            }
            else {
                print("Could not load the bundle")
            }
        }
        else {
            print("Could not create a path to the bundle")
        }
        return UIViewController()
    }
    
    public func getColissimoHomeViewController(containsColissimo: Bool) -> UIViewController {
        
        let podBundle = Bundle(for: ColissimoManager.classForCoder())
        
        if let bundleURL = podBundle.url(forResource: "LPColissimoUI", withExtension: "bundle") {
            if let bundle = Bundle(url: bundleURL) {
                let storybord = UIStoryboard(name: "Home", bundle: bundle)
                let homeViewController = storybord.instantiateViewController(withIdentifier: "ColissimoHomeViewController") as? ColissimoHomeViewController
                homeViewController?.containsColissimo = containsColissimo
                return homeViewController ?? UIViewController()
            }
            else {
                print("Could not load the bundle")
            }
        }
        else {
            print("Could not create a path to the bundle")
        }
        return UIViewController()
    }    
    
    public func getPrice(fromIsoCode: String, toIsoCode: String, weight: Double, deposit: String, insuredValue: Double, withSignature: Bool, indemnitePlus: Bool, withSurcout: Bool,success:@escaping (CLPrice)->Void, failure: @escaping (Error)->Void) {
            ColissimoAPIClient.sharedInstance.getPrice(fromIsoCode: fromIsoCode, toIsoCode: toIsoCode, weight: weight, deposit: deposit, insuredValue: insuredValue, withSignature: withSignature, indemnitePlus: indemnitePlus, withSurcout: withSurcout,
                success: { (result: CLPrice) in
                    success(result)

            },
                failure: { (error: Error) in
                    failure(error)
                    print("Error: \(error)")

            })

    }
    
    func getInitData(success:@escaping (DataContainer)->Void, failure: @escaping (Error)->Void) {
        if let initData = self.initData {

            success(initData)
        }
        else {
            let apiClient = ColissimoAPIClient.sharedInstance.getInitData(
                success: { (result: DataContainer) in
                    self.arrivalCountries = result.arrivalCountries
                    self.departureCountries = result.arrivalCountries
                    print("👀  \(#function) 👀Dparture Coutry : \( self.arrivalCountries.count)");
                    print("👀  \(#function) 👀colisFormat  : \( result.colisFormats)");
                    print("example success")
                    self.initData = result
                    success(result)
                    
            },
                failure: { (error: Error) in
                    failure(error)
                    print("Error: \(error)")
                    
            })
        }
    }

    public func getColissimoStepViewController() -> UIViewController {
        
        let podBundle = Bundle(for: ColissimoManager.classForCoder())
        
        if let bundleURL = podBundle.url(forResource: "LPColissimoUI", withExtension: "bundle") {
            if let bundle = Bundle(url: bundleURL) {
                let storybord = UIStoryboard(name: "Step", bundle: bundle)
                let firstStepViewController = storybord.instantiateViewController(withIdentifier: "FirstStepViewControllerID") as? FirstStepViewController
                return firstStepViewController ?? UIViewController()
            }
            else {
                print("Could not load the bundle")
            }
        }
        else {
            print("Could not create a path to the bundle")
        }
        return UIViewController()
    }
    
    public func getColissimoThirdStepViewController() -> UIViewController {
        
        let podBundle = Bundle(for: ColissimoManager.classForCoder())
        
        if let bundleURL = podBundle.url(forResource: "LPColissimoUI", withExtension: "bundle") {
            if let bundle = Bundle(url: bundleURL) {
                let storybord = UIStoryboard(name: "Step", bundle: bundle)
                let firstStepViewController = storybord.instantiateViewController(withIdentifier: "ThirdStepViewControllerID") as? ThirdStepViewController
                return firstStepViewController ?? UIViewController()
            }
            else {
                print("Could not load the bundle")
            }
        }
        else {
            print("Could not create a path to the bundle")
        }
        return UIViewController()
    }
    
    public func getColissimoSixthStepViewController() -> UIViewController {
        
        let podBundle = Bundle(for: ColissimoManager.classForCoder())
        
        if let bundleURL = podBundle.url(forResource: "LPColissimoUI", withExtension: "bundle") {
            if let bundle = Bundle(url: bundleURL) {
                let storybord = UIStoryboard(name: "Step", bundle: bundle)
                let sixthStepViewController = storybord.instantiateViewController(withIdentifier: "SixthStepViewControllerID") as? SixthStepViewController
                return sixthStepViewController ?? UIViewController()
            }
            else {
                print("Could not load the bundle")
            }
        }
        else {
            print("Could not create a path to the bundle")
        }
        return UIViewController()
    }
    
    public func getColissimoSixthStepPriceViewController() -> UIViewController {
        let podBundle = Bundle(for: ColissimoManager.classForCoder())
        
        if let bundleURL = podBundle.url(forResource: "LPColissimoUI", withExtension: "bundle") {
            if let bundle = Bundle(url: bundleURL) {
                let storybord = UIStoryboard(name: "Step", bundle: bundle)
                let sixthStepViewController = storybord.instantiateViewController(withIdentifier: "SixthStepPriceViewControllerID") as? SixthStepPriceViewController
                return sixthStepViewController ?? UIViewController()
            }
            else {
                print("Could not load the bundle")
            }
        }
        else {
            print("Could not create a path to the bundle")
        }
        return UIViewController()
    }
    
    public func getColissimoThirdStepHelpViewController() -> UIViewController {
        
        let podBundle = Bundle(for: ColissimoManager.classForCoder())
        
        if let bundleURL = podBundle.url(forResource: "LPColissimoUI", withExtension: "bundle") {
            if let bundle = Bundle(url: bundleURL) {
                let storybord = UIStoryboard(name: "Step", bundle: bundle)
                let firstStepViewController = storybord.instantiateViewController(withIdentifier: "ThirdStepHelpViewControllerID") as? ThirdStepHelpViewController
                return firstStepViewController ?? UIViewController()
            }
            else {
                print("Could not load the bundle")
            }
        }
        else {
            print("Could not create a path to the bundle")
        }
        return UIViewController()
    }
    
    public  func getDimensionViewController() -> UIViewController {
        
        let podBundle = Bundle(for: ColissimoManager.classForCoder())
        if let bundleURL = podBundle.url(forResource: "LPColissimoUI", withExtension: "bundle") {
            if let bundle = Bundle(url: bundleURL) {
                let storybord = UIStoryboard(name: "Dimension", bundle: bundle)
                let dimensionViewController = storybord.instantiateViewController(withIdentifier: "ColissimoDimensionViewController") as? ColissimoDimensionViewController
                return dimensionViewController ?? UIViewController()
            }
            else {
                print("Could not load the bundle")
            }
        }
        else {
            print("Could not create a path to the bundle")
        }
        return UIViewController()
    }
    
    
    public  func getValidViewController() -> UIViewController {
        
        let podBundle = Bundle(for: ColissimoManager.classForCoder())
        if let bundleURL = podBundle.url(forResource: "LPColissimoUI", withExtension: "bundle") {
            if let bundle = Bundle(url: bundleURL) {
                let storybord = UIStoryboard(name: "Dimension", bundle: bundle)
                let dimensionViewController = storybord.instantiateViewController(withIdentifier: "ValidDimensionViewController") as? ValidDimensionViewController
                return dimensionViewController ?? UIViewController()
            }
            else {
                print("Could not load the bundle")
            }
        }
        else {
            print("Could not create a path to the bundle")
        }
        return UIViewController()
    }
    
    public  func getInvalidViewController() -> UIViewController {
        
        let podBundle = Bundle(for: ColissimoManager.classForCoder())
        if let bundleURL = podBundle.url(forResource: "LPColissimoUI", withExtension: "bundle") {
            if let bundle = Bundle(url: bundleURL) {
                let storybord = UIStoryboard(name: "Dimension", bundle: bundle)
                let dimensionViewController = storybord.instantiateViewController(withIdentifier: "InvalidDimensionViewController") as? InvalidDimensionViewController
                return dimensionViewController ?? UIViewController()
            }
            else {
                print("Could not load the bundle")
            }
        }
        else {
            print("Could not create a path to the bundle")
        }
        return UIViewController()
    }
    
    
    public func fetchCountries() {
        ColissimoAPIClient.sharedInstance.getInitData(success: { successResult in
            // Add departure countries
            self.departureCountries.removeAll()
            self.departureCountries = successResult.departuresCountries
            self.defaultDepartureCountry = successResult.defaultDepartureCountry
            
            // Add arrival countries
            self.arrivalCountries.removeAll()
            self.arrivalCountries = successResult.arrivalCountries
            self.defaultArrivalCountry = successResult.defaultArrivalCountry
        }) { error in
            print(error.localizedDescription)
        }
    }
    
    func getCountries(isoDeparture : String, isoArrival: String)->(CLCountry,CLCountry){
        self.selectedDeparture = self.departureCountries.filter({ country -> Bool in
            return country.isocode! == isoDeparture
        }).first
        self.selectedArrival = self.arrivalCountries.filter({ country -> Bool in
            return country.isocode! == isoArrival
        }).first
        
        print("👀  \(#function) 👀 \n arrival:\(String(describing: selectedArrival.isocode)) DEPART : \(String(describing: selectedDeparture.isocode))");
       
        return (selectedDeparture , self.selectedArrival)
    }
    
}
