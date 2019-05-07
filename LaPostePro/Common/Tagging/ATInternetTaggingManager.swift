//
//  ATInternetTagManager.swift
//  LaPostePro
//
//  Created by Lassad Tiss on 12/09/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import ATInternet_iOS_ObjC_SDK
import LPSharedMCM

class ATInternetTaggingManager: NSObject {

    @objc static let sharedManager = ATInternetTaggingManager()
    var tracker = ATInternet.sharedInstance().defaultTracker
    
    // Configuration
    
    private func baseTrackingConfig() {
        
        let tagLogSubDomain = TaggingData.kATTagSubDomain
        
        let tagSiteID = EnvironmentUrlsManager.sharedManager.getATTagSiteId()
        
        let configuration : [AnyHashable : Any] = [
            "log":tagLogSubDomain,
            "logSSL":"logs",
            "domain":"xiti.com",
            "pixelPath":"/hit.xiti",
            "site":tagSiteID,
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
        self.tracker?.delegate = self
        
        if KeychainService().isValidToken() == .valid {
            _ = self.tracker?.identifiedVisitor.setWithTextId(UserAccount.shared.customerInfo?.customerId)
            _ = self.tracker?.customVars.add(withId: 1, value: "1", type: .app)
        } else {
            _ = self.tracker?.customVars.add(withId: 1, value: "0", type: .app)
        }
        
    }
    
    // Screen
    
    private func buildScreenWith(pageName : String, chapter1 : String?, chapter2 : String?, level2 : Int32?)  -> ATScreen {
        let myScreen : ATScreen = (self.tracker?.screens.add(withName: pageName))!
        if (chapter1 != nil) {
            myScreen.chapter1 = chapter1
        }
        if (chapter2 != nil) {
            myScreen.chapter2 = chapter2
        }
        if (level2 != nil) {
            myScreen.level2 = level2!
        }
        return myScreen
    }
    
    func sendTrackPage(pageName : String, chapter1 : String?, chapter2 : String?, level2 : Int32?) {
        self.baseTrackingConfig()
        let screen = buildScreenWith(pageName: pageName, chapter1: chapter1, chapter2: chapter2, level2: level2)
        Logger.shared.debug("******** ATInternetTaggingManager :: sendTrackPage :: \(pageName) _ \(chapter1 ?? "") _ \(chapter2 ?? "") \(level2 ?? 0)")
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
        Logger.shared.debug("******** ATInternetTaggingManager :: sendTrackClick :: \(clickLibelle) _ \(pageName ?? "") _ \(chapter1 ?? "") _ \(chapter2 ?? "") \(level2 ?? 0)")
        click.sendTouch()
    }
    
    // ORDERS
    
    @objc func sendTrackOrder(paymentSummaryData : MCMPaymentSummaryData? , cart : HYBCart?) {
        self.baseTrackingConfig()
        guard paymentSummaryData != nil && cart != nil else {
            // ERROR
            return
        }
        guard let orderId = paymentSummaryData?.orderId, let totalAmount = cart?.totalPrice else {
            // ERROR
            return
        }
        
        let order = self.tracker?.orders.add(withId: orderId, turnover: totalAmount.value.doubleValue)
        order?.isNewCustomer = (paymentSummaryData?.orderIsNewCient == "true")
        
//        if let cartSubtotal = cart?.subTotal, let cartTotalTax = cart?.totalTax, let cartTotalPrice = cart?.totalPriceWithTax {
//            _ = order?.amount.setWithAmountTaxFree(cartSubtotal.value.doubleValue, amountTaxIncluded: cartTotalPrice.value.doubleValue, taxAmount: cartTotalTax.value.doubleValue)
//            // ADJUST
//            AdjustTagManager.sharedManager.trackEventToken(AdjustTagManager.kOrderToken, price: cartSubtotal.value.doubleValue)
//        }
        
        if let cartDeliveryCost = cart?.deliveryCost {
            _ = order?.delivery.setWithShippingFeesTaxFree(cartDeliveryCost.value.doubleValue, shippingFeesTaxIncluded: cartDeliveryCost.value.doubleValue, deliveryMethod: "2[livraison_standard]")
        }
        
        let paymentMode = self.getPaymentMode(paymentSummaryData?.orderPaymentType ?? "")
        order?.paymentMethod = paymentMode
        
        _ = self.tracker?.customVars.add(withId: 1, value: "1", type: .app)
        
        // TODO :: PRODUCTS
        sendTagWithCart(cart: cart!)
        
        
        if cart?.appliedVouchers != nil, let voucher = cart?.appliedVouchers.first as? HYBVoucher {
            _ = order?.discount.setWithDiscountTaxFree(voucher.value.doubleValue, discountTaxIncluded: voucher.value.doubleValue, promotionalCode: voucher.code)
        }
        
        let screen = buildScreenWith(pageName: TaggingData.kPaiementConfirmation, chapter1: TaggingData.kTunnel, chapter2: nil, level2: TaggingData.kCommerceLevel)
//        screen.isBasketScreen = true
//        tracker?.products.sendViews()
        screen.sendView()
        self.tracker?.cart.unset()
        
        Logger.shared.debug("******** ATInternetTaggingManager :: sendTrackOrder ::")
        
    }
    
    func sendTagWithCart(cart: HYBCart) {
        _ = self.tracker?.cart.setWithId(cart.code)
        for entry in (cart.entries as? [HYBOrderEntry])! {
            if !entry.isAttachementColissimo(){
                var productString = ""
                let productId = entry.product.code
                var productName = entry.product.name
                productName = productName?.replacingOccurrences(of: " - ", with: "_")
                productName = productName?.replacingOccurrences(of: " ", with: "_")
                productName = productName?.uppercased()
                
                if entry.isColissimo() {
                    productString = generateProductStringColissimo(entry: entry) ?? ""
                } else {
                    productString = "[produit philaposte pro]::[NA]::\(productId ?? "")[\(productName ?? "")])"
                }
                
                let quantity = entry.quantity
                let unitPrice = Double(truncating: entry.basePrice.value)
                
                trackProduct(code: productId!, name: productName!, category: productString, quantity: quantity as! Int32, unitPrice: unitPrice)
            }
        }
    }
    
    func generateProductStringColissimo(entry: HYBOrderEntry) -> String?{
        guard let colisData = entry.options.colissimoColisData else {
            print ("invalid colissimo data")
            return nil
        }
        
        let firstLavel = "e-services"
        let secondLavel = "Colissimo"
        
        let thirdLavel = ((colisData.fromISOCode ?? "fr") + "_" + (colisData.toISOCode ?? "fr")).uppercased()
        let fourthLavel = transformMode(colisData.modeDepot ?? "") + "_" + transformMode(colisData.modeLivraison ?? "")
        let fifthLavel = String(describing: colisData.poidsColis!) + "_" + "IndemInteg"
        let sixthLavel = (colisData.typeColis ?? "standard").lowercased()
        
        return "\(firstLavel)::\(secondLavel)::\(thirdLavel)::\(fourthLavel)::\(fifthLavel)::\(sixthLavel)"
    }
    
    func transformMode(_ string: String) -> String {
        switch string {
        case "BUREAU_POSTE":
            return "bp"
        case "BOITE_LETTRE":
            return "bal"
        case "MAIN_PROPRE":
            return "contre-signature"
        default:
            return "bp"
        }
    }
    
    func trackProduct(code: String, name: String, category: String, quantity: Int32, unitPrice: Double) {
        let categoryList : [String] = category.components(separatedBy:"::")
        var product : ATProduct?

        if categoryList.count == 7 {
//            let productCode = categoryList[6]+"["+categoryList[6]+"]"
            let productCode = code+"["+name+"]"
            product = self.tracker?.cart.products.add(withId: productCode)
            if let result = prepareValue(categoryList[0]) {
                product?.category1 = result
            }
            if let result = prepareValue(categoryList[1]) {
                product?.category2 = result
            }
            if let result = prepareValue(categoryList[2]) {
                product?.category3 = result
            }
            if let result = prepareValue(categoryList[3]) {
                product?.category4 = result
            }
            if let result = prepareValue(categoryList[4]) {
                product?.category5 = result
            }
            if let result = prepareValue(categoryList[5]) {
                product?.category6 = result
            }
        }
        else {
            let productCode = code+"["+name+"]"
            product = self.tracker?.cart.products.add(withId: productCode)
            product?.category1 = prepareValue(category)
        }
        
        product?.discountTaxIncluded = 0
        product?.quantity = quantity
        product?.unitPriceTaxFree = unitPrice
        product?.unitPriceTaxIncluded = unitPrice
        
        Logger.shared.debug("******** ATInternetTaggingManager :: trackProduct :: \(product?.productId)")
        Logger.shared.debug("******** ATInternetTaggingManager :: trackProduct :: \(category)")

    }
    
    func prepareValue(_ text : String) -> String? {
        var result = ""
        var value = text.replacingOccurrences(of: "[", with: "")
        value = value.replacingOccurrences(of: "]", with: "")
        if value == "" {
            value = "NA"
        }
        let hash = value.hashCode()
        
        result = "\(hash)"+"["+value+"]"
        return result
    }
    
    private func getPaymentMode(_ paymentMode : String) -> Int32 {
        if paymentMode == "CB" {
            return 1
        }
        else if paymentMode == "VISA" {
            return 2
        }
        else if paymentMode == "MASTERCARD" {
            return 3
        }
        else if paymentMode == "PAYPAL" {
            return 9
        }
        else if paymentMode == "PAYLIB" {
            return 12
        }
        else if paymentMode == "CREDITS" {
            return 13
        }
        return 0
    }
    
}
    // 1) Here is our Character extension
    private extension Character {
        var asciiValue: UInt32? {
            return String(self).unicodeScalars.filter{$0.isASCII}.first?.value
        }
    }
    
    private extension String {
        // 2) ascii array to map our string
        var asciiArray: [UInt32] {
            return unicodeScalars.filter{$0.isASCII}.map{$0.value}
        }
        
        // this is our hashCode function, which produces equal output to the Java or Android hash function
        func hashCode() -> Int32 {
            var h : Int32 = 0
            for i in self.asciiArray {
                h = 31 &* h &+ Int32(i) // Be aware of overflow operators,
            }
            return h
        }
}


extension ATInternetTaggingManager: ATTrackerDelegate {
    func buildDidEnd(_ status: ATHitStatus, message: String!) {
        Logger.shared.debug("\n******** Debug :: ATInternetTaggingManager :: buildDidEnd :: " + message!)
    }
    
    func sendDidEnd(_ status: ATHitStatus, message: String!) {
        Logger.shared.debug("\n******** Debug :: ATInternetTaggingManager :: sendDidEnd :: " + message!)
    }
    
    func warningDidOccur(_ message: String!) {
        Logger.shared.debug("\n******** Debug :: ATInternetTaggingManager :: warningDidOccur :: " + message!)
    }
    
    func errorDidOccur(_ message: String!) {
        Logger.shared.debug("\n******** Debug :: ATInternetTaggingManager :: errorDidOccur :: " + message!)
    }
}
