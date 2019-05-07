//
//  ShippingCartViewModel.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 23/07/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit
import Alamofire
import LPSharedMCM
import SwiftyJSON

class ShippingCartViewModel: NSObject {
    
    var billingAddress: DeliveryAddress?
    var CGVChecked : Bool = false
    var iframeColissimoSuccess : Bool = false
    private var useTheSameAddrees = true
    
    override init() {
        super.init()
        self.billingAddress = self.createAddressFromUserAccount()
    }
    
    private func executeGetDeliveryMode(callback:@escaping (String?, LPNetworkError?) -> ()) {
        (HYBB2CServiceWrapper.sharedInstance() as! HYBB2CServiceWrapper).backEndService.getDeliveryModeRequest { (deliveries, error) in
            if error == nil {
                let _deliveries = deliveries as! [String: Any]
                if let collissimoURL = _deliveries["colissimoUrl"] as? String, let colissimoParams = _deliveries["coColissimoData"] as? [String: String] {
                    let url = self.buildColissimoURL(baseUrl: collissimoURL, params: colissimoParams)
                    callback(url, nil)
                } else {
                    callback(nil, nil)
                }
            } else {
                callback(nil, error)
            }
        }
    }
    
    
    func getDeliveryMode(callback:@escaping (String?, LPNetworkError?) -> ()) {

//        if self.addressExistInCart() == false {
            self.setDeliveryAddress(address: self.createAddressFromUserAccount()) { (error) in
                if error == nil {
                    self.executeGetDeliveryMode(callback: callback)
                }
                else {
                    callback(nil, error)
                }
            }
//        }
//        else {
//            self.executeGetDeliveryMode(callback: callback)
//        }
    }
    
    private func buildColissimoURL(baseUrl: String, params: [String: String]) -> String {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        var devMode = ""
        #if DEBUG
            devMode = "devMode=1"
        #endif
        
        //var  urlFinal = baseUrl + "?\(devMode)&pudoFOId=\(params["pudofoid"] ?? "")&ceCivility=\(params["cecivility"] ?? "")&ceName=\(params["cename"] ?? "")&ceFirstName=\(params["cefirstname"] ?? "")&ceCompanyName=\(params["cecompanyname"] ?? "")&ceAdress1=\(params["ceadress1"] ?? "")&ceAdress3=\(params["ceadress3"] ?? "")&ceZipCode=\(params["cezipcode"] ?? "")&ceTown=\(params["cetown"] ?? "")&cePays=\(params["cepays"] ?? "")&ceEmail=\(params["ceemail"] ?? "")&cePhoneNumber=\(params["cephonenumber"] ?? "")&dyForwardingCharges=\(params["dyforwardingcharges"] ?? "")&dyForwardingChargesCMT=\(params["dyforwardingchargescmt"] ?? "")&trClientNumber=\(params["trclientnumber"] ?? "")&trOrderNumber=\(params["trordernumber"] ?? "")&orderId=\(params["orderid"] ?? "")&trInter=\(params["trinter"] ?? "")&ceLang=\(params["celang"] ?? "")&numVersion=\(params["numversion"] ?? "")&signature=\(params["signature"] ?? "")&trReturnUrlOk=\("https://" + appDelegate.getHybrisServiceHost())\(params["trreturnurlok"] ?? "")&trReturnUrlKo=\("https://" + appDelegate.getHybrisServiceHost())\(params["trreturnurlko"] ?? "")"

         let   urlFinal = baseUrl + "?\(devMode)&pudoFOId=\(params["pudofoid"] ?? "")&ceCivility=\(params["cecivility"] ?? "")&ceName=\(params["cename"] ?? "")&ceFirstName=\(params["cefirstname"] ?? "")&ceCompanyName=\(params["cecompanyname"] ?? "")&ceAdress1=\(params["ceadress1"] ?? "")&ceAdress3=\(params["ceadress3"] ?? "")&ceZipCode=\(params["cezipcode"] ?? "")&ceTown=\(params["cetown"] ?? "")&cePays=\(params["cepays"] ?? "")&ceEmail=\(params["ceemail"] ?? "")&cePhoneNumber=\(params["cephonenumber"] ?? "")&dyForwardingCharges=\(params["dyforwardingcharges"] ?? "")&dyForwardingChargesCMT=\(params["dyforwardingchargescmt"] ?? "")&trClientNumber=\(params["trclientnumber"] ?? "")&trOrderNumber=\(params["trordernumber"] ?? "")&orderId=\(params["orderid"] ?? "")&trInter=\(params["trinter"] ?? "")&ceLang=\(params["celang"] ?? "")&numVersion=\(params["numversion"] ?? "")&signature=\(params["signature"] ?? "")&trReturnUrlOk=\(params["trreturnurlok"] ?? "")&trReturnUrlKo=\(params["trreturnurlko"] ?? "")"

        Logger.shared.debug(urlFinal)
        return  urlFinal
    }
    
    func postResultColissimo(urlString: String, completion:@escaping (Bool) -> ())   {
        
        var newString = urlString
        
        #if DEBUG
        // recette
        if EnvironmentUrlsManager.sharedManager.getHybrisServiceHost().contains("dpart") {
                    newString = urlString.replacingOccurrences(of: "api", with: "dpart")
        }

        #endif
        
        let url = URL(string: newString)
        
        let keychainService = KeychainService()
        let authorization = String(format: "Bearer %@", keychainService.get(key: keychainService.accessTokenkey) ?? "")
        let headers : [String: String] = [
            "Authorization": authorization,
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        let params = [
            "" : ""
        ]
        
        Alamofire.request(url!, method: HTTPMethod.post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: { response in
            if ((response.response?.statusCode ?? 0) >= 200 && (response.response?.statusCode ?? 0) <= 299) {
                self.iframeColissimoSuccess = true
                completion(true)
            }
            else {
                completion(false)
            }
        })
        
    }
    
    func setDeliveryAddress(address: DeliveryAddress, completion: @escaping (LPNetworkError?) -> ()) {
        let hybAddress = address.hybAddress()
        hybAddress.country.isocode = hybAddress.country.isocode.lowercased()
        if hybAddress.titleCode == nil {
            hybAddress.titleCode = "mr"
        }
        let dict = MCMAddressToDictionaryMapper.mapHYBAddressToDictionary(forHybrisAPI: hybAddress)
        MCMCartManager.shared().createAddress(dict as! [AnyHashable : Any], forCart: "current", withCallback: { result, error in
            if error == nil {
                completion(error)
//                MCMCartManager.shared().setCartDeliveryModeWithDeliveryId("so-colissimo-gross", cartId: "current", withCallback: { cart, error in
//                    completion(error)
//                })
            }
            else {
                completion(error)
            }
        })
    }
    
    func setPaymentAddress(address: DeliveryAddress, completion:@escaping (LPNetworkError?) -> ()) {
        let hybAddress = address.hybAddress()
        hybAddress.country.isocode = hybAddress.country.isocode.lowercased()
        guard let dict = MCMAddressToDictionaryMapper.mapHYBAddressBillingAddressPrefixToDictionary(forHybrisAPI: hybAddress) as? [String : Any]? else {
            return // error
        }
        MCMCartManager.shared().setBillingAddressWithParams(dict, forCart: "current", withCallback: { result, error in
            if error == nil {
                completion(nil)
            }
            else {
                completion(error)
            }
        })
    }
    
    func executePayment(completion: @escaping (Bool) -> ()) {
        if CartViewModel.sharedInstance.cart?.hasOnlyEservice ?? false {
            guard let billing = self.billingAddress else {
                completion(false)
                return
            }
            self.setDeliveryAddress(address: self.createAddressFromUserAccount()) { (error) in
                if error == nil {
                    self.setPaymentAddress(address: billing, completion: { (error) in
                        completion(error == nil)
                    })
                }
                else {
                    completion(error == nil)
                }
            }
        }
        else {
            guard let billing = self.billingAddress else {
                completion(false)
                return
            }
            self.setPaymentAddress(address: billing, completion: { (error) in
                completion(error == nil)
            })
        }
    }

    func addressExistInCart() -> Bool {
        return CartViewModel.sharedInstance.cart?.deliveryAddress != nil
    }
    
    func getDeliveryAddress() -> DeliveryAddress? {
        if let deliveryAddress = CartViewModel.sharedInstance.cart?.deliveryAddress {
            if iframeColissimoSuccess {
                return DeliveryAddress.deliveryAddressToHybAdress(deliveryAddress)
            }
        }
        return nil
    }
    
    func isOnlyService() -> Bool {
        return CartViewModel.sharedInstance.cart?.hasOnlyEservice ?? false
    }
    
    func getAddressAlias() -> String {
        if billingAddress != nil {
            return billingAddress?.addressAlias ?? ""
        } else {
            return ""
        }
    }
    
    func getGender() -> Bool? {
        return (billingAddress?.titleCode?.lowercased().elementsEqual("M.")) ?? true
    }
    
    func getFirstName() -> String {
        if billingAddress != nil {
        return billingAddress?.firstName ?? ""
        } else {
            return ""
        }
    }
    
    func getLastName() -> String {
        if billingAddress != nil {
        return billingAddress?.lastName ?? ""
        } else {
            return ""
        }
    }
    
    func getCompanyName() -> String {
        if billingAddress != nil {
        return billingAddress?.companyName ?? ""
        } else {
            return ""
        }
    }
    
    func getCompanyService() -> String {
        if billingAddress != nil {
        return billingAddress?.companyName ?? ""
        } else {
            return ""
        }
    }
    
    func getBuilding() -> String {
        
        return ""
    }
    
    func getStreet() -> String {
        if billingAddress != nil {
        return billingAddress?.line1 ?? ""
        } else {
            return ""
        }
    }
    
    func getPostalCode() -> String {
        if billingAddress != nil {
        return billingAddress?.postalCode ?? ""
        } else {
            return ""
        }
    }
    
    func getTown() -> String {
        if billingAddress != nil {
        return billingAddress?.town ?? ""
        } else {
            return ""
        }
    }
    
    func getCountry() -> String {
        if billingAddress != nil {
        return billingAddress?.countryName ?? ""
        } else {
            return ""
        }
    }
    
    func getBillingAddress() -> DeliveryAddress {
        return billingAddress ?? (self.getDeliveryAddress() ?? DeliveryAddress())
    }
    
    func updateBillingAddress() {
        if self.useTheSameAddrees {
            self.billingAddress = self.getDeliveryAddress()
        }
    }
    
    func paymentEnabled() -> Bool {
        if CartViewModel.sharedInstance.cart?.hasOnlyEservice ?? false {
            return !(self.getBillingAddress().isEmptyAddress()) && self.CGVChecked
        }
        guard let deliveryAddress = self.getDeliveryAddress() else {
            return false
        }
        return !self.getBillingAddress().isEmptyAddress()  && !deliveryAddress.isEmptyAddress() && self.CGVChecked
    }
    
    func setUseTheSameAddress(bool: Bool) {
        self.useTheSameAddrees = bool
        if self.useTheSameAddrees {
            self.billingAddress = self.getDeliveryAddress()
        }
    }
    
    func getUseTheSameAddress() -> Bool {
        return self.useTheSameAddrees
    }
    
    private func createAddressFromUserAccount() -> DeliveryAddress {
        let address = DeliveryAddress()
        address.companyName = UserAccount.shared.customerInfo?.companyName
        address.firstName = UserAccount.shared.customerInfo?.firstName
        address.lastName = UserAccount.shared.customerInfo?.lastName
        address.line1 = UserAccount.shared.customerInfo?.defaultAddress?.line2
        //address.line2 = UserAccount.shared.customerInfo?.defaultAddress?.line2
        address.town = UserAccount.shared.customerInfo?.defaultAddress?.town
        address.postalCode = UserAccount.shared.customerInfo?.defaultAddress?.postalCode
        address.countryName = UserAccount.shared.customerInfo?.defaultAddress?.country?.name ?? ""
        address.titleCode = UserAccount.shared.customerInfo?.defaultAddress?.titleCode
        address.title = UserAccount.shared.customerInfo?.defaultAddress?.title
        address.isocode = UserAccount.shared.customerInfo?.defaultAddress?.country?.isocode ??  ""
        address.phone = UserAccount.shared.customerInfo?.phone
        return address
    }
    
}


