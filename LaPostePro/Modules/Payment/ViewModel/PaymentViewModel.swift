//
//  PaymentViewModel.swift
//  LaPostePro
//
//  Created by Matthieu Lemonnier on 17/07/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import Foundation
import LPSharedMCM
import Foundation
import UIKit

enum PaymentMode : String {
    case cb         = "CB"
    case paylib     = "PAYLIB"
    case paypal     = "PAYPAL"
}

protocol PaymentDelegate {
    func showPaymentScellius(html:String, orderNumber:String, cart:HYBCart)
    func showPayPalViewController(payment: PayPalPayment, config: PayPalConfiguration)
    func resultPaypal(success:Bool, orderNumber:String?, messageDelivery:String?)
}

class PaymentViewModel: NSObject {

    var cart: HYBCart?
    var paymentMode: PaymentMode?
    var delegate : PaymentDelegate?
    lazy var loaderManager = LoaderViewManager()
    // Delete
    var showPayment : ((String, String, HYBCart) -> ())?
    
    override init() {
        self.cart = CartViewModel.sharedInstance.cart
    }
    
    func cartContainColissimo() -> Bool {
        guard let cart =  self.cart else {
            return false
        }
        for entry in (cart.entries as! [HYBOrderEntry]) {
            if entry.identifier != nil {
                if entry.identifier.contains("colis_") {
                    return true
                }
            }
        }
        return false
    }
    
    func provider(paymentMode: PaymentMode) {
        loaderManager.showLoderView()
        self.paymentMode = paymentMode
        
        self.setPaymentMode(self.paymentMode!, completion: { [weak self] success in
            if success {
                                MCMCartManager.shared().retrieveCart(callback: { cart, error in
                                    if error == nil {
                                        self?.cart = cart
                                        self?.executePayment(comletion: {error in
                                            
                                        })
                                    }
                                    else {
                                        self?.loaderManager.hideLoaderView()
                                    }
                                })
            }
            else {
                self?.loaderManager.hideLoaderView()
            }
        })
    }
    
    func executePayment(comletion:@escaping (LPNetworkError?) -> ()) {
        guard cart == self.cart else {
            return
        }
        
        MCMOrderManager.shared().placeOrder(with: self.cart, andExecute: { [weak self] (order, error) in
            self?.loaderManager.hideLoaderView()
            if error != nil {
                comletion(error)
                return
            }
            else {
                if(order != nil) {
                    self?.currentOrder = order
                }
                else {
                    return
                }
                if self?.paymentMode == .paypal {
                    self?.executePayPalPayment()
                }
                else {
                    if (order != nil && order?.paymentChoicesForm != nil) {
                        let params = ["paiymentMeans" : self?.paymentMode?.rawValue , "commandNumber" : order?.code ?? ""]
                        let finishSummary = MCMPaymentSummaryData.paymentSummary(withParams: params, cart: self?.cart)
                        ATInternetTaggingManager.sharedManager.sendTrackOrder(paymentSummaryData: finishSummary, cart: self?.cart)
                        
                        self?.executeSceliusPayment(order: order!)
                    }
                }
            }
        })
        }
    
    func setPaymentMode(_ mode: PaymentMode, completion: @escaping (Bool) -> ()) {
        self.paymentMode = mode
        if let valueMode = self.paymentMode == .paylib ? PaymentMode.cb.rawValue : self.paymentMode?.rawValue {
            MCMCartManager.shared().setPaymentMode("current", withParams: ["paymentModeId" : valueMode], andExecute: { result in            
                guard let msg = (result as? String?) else {
                    completion(false)
                    return // error
                }
                if msg != "success" {
                    completion(false)
                    return // error
                }
                else {
                    completion(true)
                }
            })
        }
    }
    
    private func executeSceliusPayment(order: HYBOrder) {
        if (order.code != nil && order.paymentChoicesForm != nil && self.cart != nil) {
            self.delegate?.showPaymentScellius(html: order.paymentChoicesForm, orderNumber: order.code, cart: self.cart!)
        }
    }
    
    private func executePayPalPayment() {
        self.configPaypalPayment()
        self.launchPayPal()
    }

    private var currentOrder : HYBOrder?
    // PayPal
    private var payPalConfig    : PayPalConfiguration!
    private var environment     : String!
    private var resultText      : String!

    
    
    
    
    func configPaypalPayment() {
        self.payPalConfig = PayPalConfiguration()
        self.payPalConfig.payPalShippingAddressOption = PayPalShippingAddressOption.provided
        self.payPalConfig.acceptCreditCards = false
        self.payPalConfig.merchantName = "La Poste"
        self.payPalConfig.merchantPrivacyPolicyURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full")
        self.payPalConfig.merchantUserAgreementURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full")
        self.payPalConfig.languageOrLocale = Locale.preferredLanguages[0]
        
        
        #if DEBUG
            self.environment = PayPalEnvironmentSandbox;
        #else
            self.environment = PayPalEnvironmentProduction;
        #endif
        
        PayPalMobile.preconnect(withEnvironment: self.environment)
        
    }
    
    func makePayPalPayment() {
        let params = ["paymentModeId":"PAYPAL"]
        MCMCartManager.shared().setPaymentMode(self.cart?.code, withParams: params) { (result) in
            guard let msg = (result as? String?) else {
                return // error
            }
            if msg != "success" {
                return // error
            }
            else {
                MCMOrderManager.shared().placeOrder(with: self.cart, andExecute: { (order, error) in
                    self.currentOrder = order
                    if (error == nil) && (order != nil) && (order?.paymentChoicesForm.isEmpty == false) {
                        if self.paymentMode == PaymentMode.paypal {
                            self.launchPayPal()
                        }
                        else {
                            // SHOW CB PAYMENT
                        }
                    }
                    if (error != nil) {
                        
                    }
                })
            }
        }
        
        
    }
    
    func launchPayPal() {
        let total : NSDecimalNumber = (self.currentOrder?.totalPriceWithTax.value)!
        
        let payment = PayPalPayment()
        payment.amount = total
        payment.currencyCode = "EUR"
        
        
        var articleTxt = "produits"
        if self.currentOrder?.totalUnitCount == 1 {
            articleTxt = "produit"
        }
        
        guard let cart = self.cart else {
            return
        }
        
        payment.custom = self.currentOrder?.paymentCustomData
        payment.shortDescription = "\(self.cart?.totalUnitCount ?? 0) \(articleTxt)"
        if cart.paymentAddress != nil {
            let shipmentAddress = PayPalShippingAddress()
            shipmentAddress.recipientName   = ("\(cart.paymentAddress.title ?? "") \(self.cart?.paymentAddress.firstName ?? "") \(cart.paymentAddress.lastName ?? "")").uppercased()
            shipmentAddress.line1           = cart.paymentAddress.line1.uppercased()
            if (cart.paymentAddress.line2 == nil) {
                shipmentAddress.line2           = ""
            }
            shipmentAddress.city            = cart.paymentAddress.town.uppercased()
            shipmentAddress.postalCode      = cart.paymentAddress.postalCode.uppercased()
            shipmentAddress.countryCode     = cart.paymentAddress.country.isocode.uppercased()
            shipmentAddress.state           = cart.paymentAddress.country.name.uppercased()
            payment.shippingAddress = shipmentAddress
        }
        if payment.processable {
            // NEED ADD
            self.delegate?.showPayPalViewController(payment: payment, config: self.payPalConfig)
            //self.view.showPayPalViewController(payment: payment, config: self.payPalConfig)
        }
        else {
            // NEED ADD
            //self.view.showError(message: nil)
            //loaderManager.hideLoaderView()
        }
    }
    
    func payPalPaymentCompleted(completedPayment : PayPalPayment) {
        self.resultText = completedPayment.description
        let response = completedPayment.confirmation["response"] as? [AnyHashable : Any]
        let params = ["paymentID" : response!["id"] ?? ""]
        MCMCartManager.shared().executePayPalPayment(self.currentOrder?.code, withParams: params) { (result) in
            guard let msg = (result as? String?) else {
                return // error
            }
            if msg != "success" {
                // NEED ADD
                self.delegate?.resultPaypal(success: false, orderNumber: nil, messageDelivery: nil)
            }
            else {
                let params = ["paiymentMeans" : "PAYPAL" , "commandNumber" : self.currentOrder?.code ?? ""]
                let finishSummary = MCMPaymentSummaryData.paymentSummary(withParams: params, cart: self.cart)
                ATInternetTaggingManager.sharedManager.sendTrackOrder(paymentSummaryData: finishSummary, cart: self.cart)
                
                // NEED ADD
                self.delegate?.resultPaypal(success: true, orderNumber: self.currentOrder?.code, messageDelivery: self.cart?.estimateShipmentDateLabel)
                //self.view.transitionToCallbackStatusScreenWithStatus(success: true, orderNumber: self.currentOrder?.code)
            }
        }
        
    }
    
}

