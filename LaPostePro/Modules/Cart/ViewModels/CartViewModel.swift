//
//  CartViewModel.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 15/05/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit
import RealmSwift
import LPSharedMCM

class CartViewModel: NSObject {
    //singleton used to keep variable in app life cycle
    @objc static let sharedInstance = CartViewModel()
    var firstDeliveryDate: String?
    var secondDeliveryDate: String?
    lazy var list = [HYBProduct]()
    let hybServiceWrapper = (HYBB2CServiceWrapper.sharedInstance() as! HYBB2CServiceWrapper)
    var productTotalCountInCart: Int? {
        get {
            return self.totalUnitCount()
        }
    }
    
    var totalPrice: Float = 0
    @objc var cart: HYBCart?

    var products = [Product]()
    var priceWithTVA: HYBPrice?
    var priceWithoutTVA: HYBPrice?
    var shippingPrice : HYBPrice?
    var totalTVA: HYBPrice?
    var discount: HYBPrice?
    var activeVoucher: String? {
        get {
            guard let cart = self.cart else {
                return nil
            }
            if (cart.appliedVouchers != nil && cart.appliedVouchers.count > 0) {
                return (cart.appliedVouchers[0] as! HYBVoucher).voucherCode
            }
            return nil
        }
    }
    
    @objc func isDepositModePostOffice() -> Bool {
        if cartContainColissimo() {
            guard let cart = self.cart else {
                return false
            }
            
            for entry in (cart.entries as! [HYBOrderEntry]) {
                if entry.isColissimo() {
                    return entry.options.colissimoColisData.modeDepot == "BUREAU_POSTE"
                }
            }
        }
        return false
    }
    
    @objc func getDepositDate() -> String {
        if cartContainColissimo() {
            guard let cart = self.cart else {
                return ""
            }
            
            for entry in (cart.entries as! [HYBOrderEntry]) {
                if entry.isColissimo() {
                    return entry.options.colissimoColisData.dateDepot!
                }
            }
        }
        return ""
    }
    
    @objc func cartContainColissimo() -> Bool {
        guard let cart = self.cart else {
            return false
        }

        guard let entries = cart.entries else { return false }

        for entry in (entries as! [HYBOrderEntry]) {
            if entry.isColissimo() {
                return true
            }
        }
        return false
    }
    
    func deliveryCost() -> String {        

        guard let deliveryCost = self.cart?.deliveryCost else {
            return "Offerts"
        }
        if let cost = deliveryCost.value {
            let doubleCost = Double(truncating: cost)
            if doubleCost > 0.0 {
                return self.cart?.deliveryCost.formattedValue ?? ""
            }
        }
        return "Offerts"
    }
    
    func getCart(onCompletion: @escaping (HYBCart) -> Void) {
        hybServiceWrapper.backEndService.retrieveCurrentCartAndExecute { (cart, error) in
            // TODOs: notify header to update product number
            self.products = [Product]()
            if error == nil {
                var totalPricePhysicalProduct: Float = 0
                self.cart = cart

                self.priceWithTVA = cart!.totalPriceWithTax
                self.priceWithoutTVA = cart!.totalNetPrice
                self.totalTVA = cart!.totalTax
                self.discount = cart!.totalDiscounts
                self.shippingPrice = cart!.deliveryCost
                
                // SAVE DELIVERY ADDRESS
//                if let deliveryAddress = cart?.deliveryAddress {
//                    let deliveyAddress = DeliveryAddress()
//                    deliveyAddress.addAddressToRealm(deliveryAddress: deliveryAddress)
//                }

                
                // TODOMLE add condition show colissimo
                if let entries = cart?.entries {
                    var stickers = [Product]()
                    for entry in entries as! [HYBOrderEntry] {
                        if Int(entry.product.code) != nil {
                            totalPricePhysicalProduct += entry.product.price.value.floatValue * entry.quantity.floatValue
                        }
                        if [Constants.stickerUnitProductCode, Constants.stickerSmallPackCode, Constants.stickerBigPackCode].contains(entry.product.code) {
                            stickers.append(Product(hybEntry: entry))
                        } else {                            
                            if !entry.isAttachementColissimo() {
                                self.products.append(Product(hybEntry: entry))
                            }
                        }
                    }
                    self.products.append(contentsOf: stickers)
                    self.totalPrice = cart!.thresholdForFreeShipment.floatValue - totalPricePhysicalProduct
                    let regex = Regex()
                    let date: [String] = regex.matches(for: "[0-9]+/[0-9]+/[0-9]+", in: cart!.estimateShipmentDateLabel)
                    self.firstDeliveryDate = date[0]
                    self.secondDeliveryDate = date[1]
                    if let tmpCart = self.cart, let deliveryCost = tmpCart.deliveryCost {
                        self.totalPrice = ((deliveryCost.value.floatValue <= 0) ? 0 : self.totalPrice)
                    }
                    onCompletion(cart!)
                } else {
                    self.totalPrice = cart!.thresholdForFreeShipment.floatValue
                    onCompletion(cart!)
                }
                //onCompletion(cart!)
                NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "update_cart")))
            } else {
                Logger.shared.debug("Error on getCart")
                //LoaderViewManager.shared.hideLoaderView() this viewModel is a Singleton so from the viewmodel I can't hide the loading
                // so in the case or error the timeout will close the loading until this VM has a refactor like not singleton
            }
        }
    }

    func addProductToCart(product: Product, quantityToAdd: Int, onCompletion: @escaping (Bool, HYBCart?) -> Void) {
        hybServiceWrapper.backEndService.addProduct(toCurrentCart: product.id, amount: NSNumber.init(value: quantityToAdd)) { (cart, _) in
            // TODOs: notify header to update product number
            if cart != nil {
                self.cart = cart
                let tmpProduct = product
                tmpProduct.quantityInCart  = NSNumber(value: quantityToAdd)
                self.products.append(tmpProduct)
                NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "update_cart")))
                onCompletion(true, cart)
            }
        }
    }

    func discountValue() -> String {
        guard let voucher = (self.cart?.appliedVouchers as? [HYBVoucher])?.first else {
            return ""
        }
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.decimalSeparator = ","
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        
        return (numberFormatter.string(from: voucher.value) ?? "--") + " €"
    }
    
    func applyCodePromo(promoCode: String, onCompletion: @escaping (Bool) -> Void) {
        MCMCartManager.shared()?.setVoucherWithId(promoCode, to: CartViewModel.sharedInstance.cart!, andExecute: { (success, error) in
            onCompletion(success)
        })
    }
    
    func removeVoucher(onCompletion: @escaping (Bool) -> Void) {
        if self.cart?.appliedVouchers != nil {
            if (self.cart?.appliedVouchers.count)! > 0 {
                guard let voucherCode = (self.cart?.appliedVouchers as? [HYBVoucher])?.first?.voucherCode else {
                    return
                }
                MCMCartManager.shared()?.removeVoucher(withId: voucherCode, from: CartViewModel.sharedInstance.cart!, andExecute: { (success, error) in
                    onCompletion(success)
                    return
                })
                return
            }
        }
        onCompletion(false)
    }

    func getProductListForCarousel(query: String, completion: (@escaping ([HYBProduct]) -> Void)) {
        (MCMProductManager.sharedManager() as! MCMProductManager).getProductsAndDetails(byQuery: query) { (productList, _, _, _, _, _) in
            if productList != nil {
                completion(productList as! [HYBProduct])
            } else {
                completion(self.list)
            }
        }
    }

    
    func getReconditionningProductFromCart() -> [Product] {
        let stickerOrderArray = (self.cart?.entries as! [HYBOrderEntry]).filter { [Constants.stickerUnitProductCode, Constants.stickerSmallPackCode, Constants.stickerBigPackCode].contains($0.product.code) }
        if stickerOrderArray.count != 0 {
            var totalCount = 0
            for stickerOrder in stickerOrderArray {
                if stickerOrder.product.code.elementsEqual(Constants.stickerBigPackCode) {
                    totalCount = totalCount + (Int(truncating: stickerOrder.quantity) * 120)
                } else if stickerOrder.product.code.elementsEqual(Constants.stickerSmallPackCode) {
                    totalCount = totalCount + (Int(truncating: stickerOrder.quantity) * 12)
                } else {
                     totalCount = totalCount + Int(truncating: stickerOrder.quantity)
                }
            }
            return applyReconditioningCounting(for: totalCount)
        } else {
            return [Product]()
        }
    }
    
    private func applyReconditioningCounting(for stickerCount: Int) -> [Product] {
        var productList = [Product]()
        var result = stickerCount / 120
        if result == 0 {
            result = stickerCount / 12
            if result == 0 {
                // sticker count equal to number of sticker unit
                //pack 120 = 0, pack 12 = 0, unit = stickerCount
                let product = Product()
                product.id = Constants.stickerUnitProductCode
                product.quantityInCart = NSNumber(value: stickerCount)
                productList.append(product)
            } else {
                let modulo = stickerCount % 12
                // result equal to sticker pack 12
                // modulo equal to stickr unit
                //pack 120 = 0, pack 12 = result, unit = modulo
                if modulo == 0 {
                    let stickerSmallPack = Product()
                    stickerSmallPack.id = Constants.stickerSmallPackCode
                    stickerSmallPack.quantityInCart = NSNumber(value: result)
                    productList.append(stickerSmallPack)
                } else {
                    let stickerUnitProduct = Product()
                    stickerUnitProduct.id = Constants.stickerUnitProductCode
                    stickerUnitProduct.quantityInCart = NSNumber(value: modulo)
                    productList.append(stickerUnitProduct)
                    let stickerSmallPack = Product()
                    stickerSmallPack.id = Constants.stickerSmallPackCode
                    stickerSmallPack.quantityInCart = NSNumber(value: result)
                    productList.append(stickerSmallPack)
                }
            }
        } else {
            // result equal to pack 120
            var modulo = stickerCount % 120
            let firstStepCount = modulo / 12
            // firstStepCount equal to 12 pack
            if firstStepCount == 0 {
                //pack 120 = result, pack 12 = 0, unit = modulo
                //modulo equal to unit sticker
                if modulo == 0 {
                    let stickerBigPack = Product()
                    stickerBigPack.id = Constants.stickerBigPackCode
                    stickerBigPack.quantityInCart = NSNumber(value: result)
                    productList.append(stickerBigPack)
                } else {
                    let stickerUnitProduct = Product()
                    stickerUnitProduct.id = Constants.stickerUnitProductCode
                    stickerUnitProduct.quantityInCart = NSNumber(value: modulo)
                    productList.append(stickerUnitProduct)
                    let stickerBigPack = Product()
                    stickerBigPack.id = Constants.stickerBigPackCode
                    stickerBigPack.quantityInCart = NSNumber(value: result)
                    productList.append(stickerBigPack)
                }
            } else {
                // first step count equal to pack 12
                modulo = modulo % 12
                // modulo equal to unit sticker
                //pack 120 = result, pack 12 = firstStepCount, unit = modulo
                if modulo == 0 {
                    let stickerSmallPack = Product()
                    stickerSmallPack.id = Constants.stickerSmallPackCode
                    stickerSmallPack.quantityInCart = NSNumber(value: firstStepCount)
                    productList.append(stickerSmallPack)
                    let stickerBigPack = Product()
                    stickerBigPack.id = Constants.stickerBigPackCode
                    stickerBigPack.quantityInCart = NSNumber(value: result)
                    productList.append(stickerBigPack)
                } else {
                    let stickerUnitProduct = Product()
                    stickerUnitProduct.id = Constants.stickerUnitProductCode
                    stickerUnitProduct.quantityInCart = NSNumber(value: modulo)
                    productList.append(stickerUnitProduct)
                    let stickerSmallPack = Product()
                    stickerSmallPack.id = Constants.stickerSmallPackCode
                    stickerSmallPack.quantityInCart = NSNumber(value: firstStepCount)
                    productList.append(stickerSmallPack)
                     let stickerBigPack = Product()
                    stickerBigPack.id = Constants.stickerBigPackCode
                    stickerBigPack.quantityInCart = NSNumber(value: result)
                    productList.append(stickerBigPack)
                }
            }
        }
        return productList
    }

    func totalUnitCount() -> Int {
        var countItem = 0
        for product in self.products {
            if product.quantityInCart != nil {
                countItem += product.quantityInCart!.intValue
            }
        }
        return countItem
    }

    
    
    func needReconditioning() -> Bool {
        let stickerOrderArray = (self.cart?.entries as? [HYBOrderEntry])?.filter { [Constants.stickerUnitProductCode, Constants.stickerSmallPackCode].contains($0.product.code) } ?? []
        if stickerOrderArray.count > 0 {
            if let stickerUnit = stickerOrderArray.first(where: {$0.product.code.elementsEqual(Constants.stickerUnitProductCode)}) {
                if (stickerUnit.quantity.intValue / 12) != 0 {
                   return true
                }
            }
            if let stickerSmallPack = stickerOrderArray.first(where: {$0.product.code.elementsEqual(Constants.stickerSmallPackCode)}) {
                if ((stickerSmallPack.quantity.intValue * 12) / 120) != 0 {
                   return true
                }
            }
            return false
        } else {
            return false
        }
    }

    // Delete product using the index in cart
    func removeProductFromCart(index: Int, onCompletion: @escaping (Bool) -> Void) {
        // TODOs: To handle connected user cart (CCU)
        MCMCartManager.shared().deleteEntry(forCartWitId: self.cart!.code, entryNumber: index as NSNumber, withCallback: { _, error in
            if error == nil {
                //CartViewModel.sharedInstance.products.remove(at: index)
                CartViewModel.sharedInstance.getCart(onCompletion: { (_) in
                    onCompletion(true)
                })
            } else {
                onCompletion(false)
            }
        })
    }

    // Updating product quantity using the index in cart
    func updateQuantity(for product: Product, quantity: Int, onCompletion: @escaping (Bool) -> Void) {
        if product.entryNumber != nil {
            MCMCartManager.shared().updateCartEntry(withId: "\(product.entryNumber!)", withAmount: quantity as NSNumber, withCallback: { success, str, error in
                CartViewModel.sharedInstance.getCart(onCompletion: { (_) in
                    onCompletion(true)
                })
            })
        }
    }
    
    func applyReconditioning(products: [Product], onCompletion: @escaping(Bool) -> Void) {
        var entryToRemove = (self.cart?.entries as! [HYBOrderEntry]).filter { [Constants.stickerUnitProductCode, Constants.stickerSmallPackCode, Constants.stickerBigPackCode].contains($0.product.code) }
        if !entryToRemove.isEmpty {
            removeProductFromCart(index: entryToRemove[0].entryNumber.intValue) { (removed) in
                if removed {
                    entryToRemove = [HYBOrderEntry]()
                    if self.cart?.entries != nil {
                        entryToRemove = (self.cart?.entries as! [HYBOrderEntry]).filter { [Constants.stickerUnitProductCode, Constants.stickerSmallPackCode, Constants.stickerBigPackCode].contains($0.product.code) }
                    }
                    if !entryToRemove.isEmpty {
                        self.removeProductFromCart(index: entryToRemove[0].entryNumber.intValue) { (removed) in
                            if removed {
                                entryToRemove = [HYBOrderEntry]()
                                if self.cart?.entries != nil {
                                    entryToRemove = (self.cart?.entries as! [HYBOrderEntry]).filter { [Constants.stickerUnitProductCode, Constants.stickerSmallPackCode, Constants.stickerBigPackCode].contains($0.product.code) }
                                }

                                if !entryToRemove.isEmpty {
                                    self.removeProductFromCart(index: entryToRemove[0].entryNumber.intValue) { (removed) in
                                        if removed {
                                            self.addForReconditioning(products: products, onCompletion: { (added) in
                                                onCompletion(true)
                                                NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "update_cart")))
                                            })
                                        }
                                    }
                                } else {
                                    self.addForReconditioning(products: products, onCompletion: { (added) in
                                        onCompletion(true)
                                        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "update_cart")))
                                    })
                                }
                            }
                        }
                    } else {
                        self.addForReconditioning(products: products, onCompletion: { (added) in
                            onCompletion(true)
                            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "update_cart")))
                        })
                    }
                }
            }
        }
//        let requestGroup = DispatchGroup()
//        for entry in entryToRemove {
//            requestGroup.enter()
//            self.removeProductFromCart(index: entry.entryNumber.intValue) { (removed) in
//                if removed {
//                    Logger.shared.debug(entry.entryNumber.stringValue + "#######")
//                    requestGroup.leave()
//                }
//            }
//        }
//        requestGroup.notify(queue: .main) {
//            let requestGroup = DispatchGroup()
//            for product in products {
//                requestGroup.enter()
//                self.addProductToCart(product: product, quantityToAdd: (product.quantityInCart?.intValue)!, onCompletion: { (added, cart) in
//                    requestGroup.leave()
//                })
//            }
//            requestGroup.notify(queue: .main) {
//                onCompletion(true)
//                NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "update_cart")))
//            }
//        }
    }
    
    private func removeForReconditioning(entryIndex: NSNumber, onCompletion: @escaping(Bool) -> Void) {
        MCMCartManager.shared().deleteEntry(forCartWitId: self.cart!.guid, entryNumber: entryIndex, withCallback: { _, error in
            if error == nil {
              onCompletion(true)
            }
        })
    }
    
    private func addForReconditioning(products: [Product], onCompletion: @escaping(Bool) -> Void) {
        var productsToAdd = products
        //addProductToCart(product: Product, quantityToAdd: Int, onCompletion
        self.addProductToCart(product: productsToAdd[0], quantityToAdd: (productsToAdd[0].quantityInCart?.intValue)!) { (_, cart) in
            if cart != nil {
                productsToAdd.remove(at: 0)
                if !productsToAdd.isEmpty {
                    self.addProductToCart(product: productsToAdd[0], quantityToAdd: (productsToAdd[0].quantityInCart?.intValue)!) { (_, cart) in
                        if cart != nil {
                            productsToAdd.remove(at: 0)
                            if !productsToAdd.isEmpty {
                                self.addProductToCart(product: productsToAdd[0], quantityToAdd: (productsToAdd[0].quantityInCart?.intValue)!) { (_, cart) in
                                    if cart != nil {
                                        onCompletion(true)
                                    }
                                }
                            }else {
                                onCompletion(true)
                            }
                        }
                    }
                } else {
                    onCompletion(true)
                }
            }
        }
    }
    
}
