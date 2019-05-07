//
//  OrderViewModel.swift
//  LaPostePro
//
//  Created by Matthieu Lemonnier on 28/08/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import Foundation
import LPSharedMCM

class OrderViewModel {
 
    var finished = false
    let sizePage: Int32 = 20
    var page: Int32 = 0
    var searchMode: Bool = false
    lazy var loaderManager = LoaderViewManager()
    private var listOrders: (sections:[String], datas:[[HYBOrderHistory]])? = nil
    private var listOrdersSearch: (sections:[String], datas:[[HYBOrderHistory]])? = nil
    private var orders: [HYBOrderHistory] = [HYBOrderHistory]()
    var detailOrder: HYBOrder? = nil
    
    func totalOrder() -> Int {
        let hybServiceWrapper = (HYBB2CServiceWrapper.sharedInstance() as! HYBB2CServiceWrapper)
        
        return Int(hybServiceWrapper.backEndService!.totalSearchResults)
    }
    
    func resetPagination() {
        let hybServiceWrapper = (HYBB2CServiceWrapper.sharedInstance() as! HYBB2CServiceWrapper)
        hybServiceWrapper.backEndService.resetPagination()
    }
    
    func hasOnlyService() -> Bool {
        guard let order = self.detailOrder else {
            return false
        }
        return order.hasOnlyService()
    }
    
    func getOrders(completion:@escaping ( ([String],[[HYBOrderHistory]])? ) -> Void) {
        
        if searchMode {
            return
        }
        
        MCMOrderManager.shared().getUserOrdersPage(page, orderStatus: "COMPLETED", andExecute: { (historyOrders, error) in
            if error == nil {
                if historyOrders == nil {
                    self.finished = true
                    completion(self.listOrders)
                }
                else {
                    let orders = (historyOrders as! [HYBOrderHistory])
                    self.orders += orders
                    self.finished = orders.count < self.sizePage
                    self.page += 1
                    self.listOrders = self.getListOrder(orders: self.orders)
                    completion(self.listOrders)
                }
            }
            else {
                completion(nil)
            }
        })
    }
    
    func getOrderDetail(code: String, completion:@escaping (HYBOrder?) -> Void) {
        self.loaderManager.showLoderView()
        MCMOrderManager.shared().getUserOrderDetail(withCode: code) { (order, error) in
            self.loaderManager.hideLoaderView()
            if error == nil {
                if let orderObj = (order as? HYBOrder) {
                    self.detailOrder = orderObj;
                    completion(orderObj)
                    return
                }
            }
            completion(nil)
        }
    }
    
    private func getListOrder(orders: [HYBOrderHistory]) -> (sections:[String], datas:[[HYBOrderHistory]]) {

        var result = (sections:[String](), datas:[[HYBOrderHistory]]())
        
        for order in orders {
            let date = order.placed.getDate()
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "FR-fr")
            dateFormatter.dateFormat = "LLLL YYYY"

            let key : String = dateFormatter.string(from:date!).capitalized
            
            if result.sections.contains(key) {
                let index = result.sections.index(of: key)
                result.datas[index!].append(order)
            }
            else {
                result.sections.append(key)
                result.datas.append([HYBOrderHistory]())
                result.datas[result.datas.count - 1].append(order)
            }
        }
        return result
    }
    
    func getLastOrder(completion:@escaping (HYBOrder?) -> Void) {
        getOrders(completion: { orders in
            if let lastOrder = self.orders.first {
                self.getOrderDetail(code: lastOrder.code, completion: { orderDetail in
                    completion(orderDetail)
                })
            }
        })
    }
    
}


// search
extension OrderViewModel {
    
    func getOrdersSearch(searchString: String, completion:@escaping ( ([String],[[HYBOrderHistory]])? ) -> Void) {
        
        MCMOrderManager.shared().getUserOrdersPage(page, orderStatus: "COMPLETED", andExecute: { (historyOrders, error) in
            if error == nil {
                if historyOrders == nil {
                    self.finished = true
                    self.listOrdersSearch = self.getListOrder(orders:self.resultSearch(orders: self.orders, strSearch: searchString))
                    completion(self.listOrdersSearch)
                }
                else {
                    let orders = (historyOrders as! [HYBOrderHistory])
                    self.orders += orders
                    self.finished = orders.count < self.sizePage
                    self.page += 1
                    self.listOrdersSearch = self.getListOrder(orders:self.resultSearch(orders: self.orders, strSearch: searchString))
                    completion(self.listOrdersSearch)
                }
            }
            else {
                completion(nil)
            }
        })
    }
    
    func resultSearch(orders:[HYBOrderHistory], strSearch: String ) -> [HYBOrderHistory] {
        var result = [HYBOrderHistory]()
        
        for order in orders {
            if(order.code.contains(strSearch)) {
                result.append(order)
            }
        }
        return result
    }
}


// Details
extension OrderViewModel {
    
    func orderRef() -> String {
        return "Commande n° \(self.detailOrder?.code ?? "" )"
    }
    
    func orderPrice() -> String {
        return detailOrder?.totalPrice.formattedValue ?? ""
    }
    
    func orderDateAndStatus() -> NSMutableAttributedString {
        let result = NSMutableAttributedString()
        let date = self.detailOrder?.created.getDate()
        result.custom("Commandé le \(date?.format("dd LLLL YYYY") ?? "")  ", font: UIFont.systemFont(ofSize: 12), color: UIColor.lightGray)
        result.custom(self.detailOrder?.statusDisplayUI() ?? "", font: UIFont.systemFont(ofSize: 13), color: UIColor.black)
        return result;
    }
    
    func buyAgain() -> Bool {
        // Liste des status
        return self.detailOrder?.status == "COMPLETED"
    }
    
    func subTotalPrice() -> String {
        return detailOrder?.totalNetPrice.formattedValue ?? ""
    }
    
    func totalWithTax() -> String {
        return detailOrder?.totalPriceWithTax.formattedValue ?? ""
    }

    func totalTax() -> String {
        return detailOrder?.totalTax.formattedValue ?? ""
    }

    
    func deliveryCost() -> String {
        return detailOrder?.deliveryCost?.formattedValue ?? ""
    }
    
    func addProductToCart(index: Int, completion: @escaping (String?) -> ()) {
        let order = self.entry(index)
        let qty = order.quantity
        let codeProduct = order.product.code
        MCMCartManager.shared()?.addProduct(toCart: codeProduct, amount: qty, andExecute: { cart, str, error in
            if error == nil && str != nil {
                completion(str)
            }
        })
    }
    
    func showProduct(index: Int, completion: @escaping (HYBProduct) -> ()) {
        let orderEntry = self.entry(index)
        let code = orderEntry.product.code
        
        if code != nil {
            self.loaderManager.showLoderView()
            ProductViewModel().getProduct(withID: code!) { (product) in
                self.loaderManager.hideLoaderView()
                if product != nil {
                    completion(product)
                }
            }
        }
    }
    
    func getDeliveryMode() -> UIImage? {
        return R.image.colissimo()
    }
    
    func getPaymentMode() -> UIImage? {
        
        if let detailOrder = self.detailOrder {
            if(detailOrder.paymentMode == PaymentMode.paypal.rawValue) {
                return R.image.payementPaypalSmall()
            }
            else if(detailOrder.paymentMode == PaymentMode.paylib.rawValue) {
                return R.image.payementPaylibSmall()
            }
        }
        return R.image.paymentCbSmall()
    }
    
    func renewOrder(completion:@escaping (String)->()) {
        if let order = self.detailOrder {
            MCMOrderManager.shared()?.renewOrder(withCode: order.code, andExecute: { status, error in
                let statusString = status as! String?
                
                if error != nil {
                    completion("Une erreur est survenue.")
                }                
                else if statusString == "success" {
                    completion("Tous les produits ont bien été ajoutés au panier.")
                }
                else if statusString == "low_stock" {
                    completion("Certains produits ne sont plus disponibles \n et n\'ont pas pu être ajoutés au panier.")
                }
                else {
                    completion("Aucun produit n\'a pu être ajouté au panier.")
                }
                NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "update_cart")))
            })
        }
    }
    
    func getBillOrder(completion: @escaping (String) -> ()) {
        if let order = self.detailOrder {
            self.loaderManager.showLoderView()
            MCMOrderManager.shared()?.getInvoiceForOrderId(order.code, andExecute: { url, error in
                self.loaderManager.hideLoaderView()
                if error == nil && url != nil {
                    completion(url!)
                }
                else {
                    // Manage Error
                }
            })
        }
    }
    
    func numberEntries() -> Int {
        // Fix product colissimo (assurance, surcout)
        var tmpIndex = 0;
        
        for entry in (detailOrder?.entries as? [HYBOrderEntry] ?? []) {
            if !entry.isAttachementColissimo() {
                tmpIndex += 1
            }
        }
        
        return tmpIndex
    }
    
    func nameProductForEntry(index: Int) -> String {
        return self.entry(index).product.name
    }
    
    func descriptionForEntry(index: Int) -> String {
        let entry = self.entry(index)

        if (entry.isColissimo() && entry.options != nil) {
            var formatColis = entry.options.colissimoColisData.typeColis
            if formatColis == nil || formatColis == "" {
                formatColis = "STANDARD"
            }
            if formatColis == "ROULEAU" {
                formatColis = "TUBE"
            }
            
            let nf = NumberFormatter()
            nf.maximumFractionDigits = 3
            nf.minimumFractionDigits = 3
            nf.minimumIntegerDigits = 1

            let weight = nf.string(from: entry.options.colissimoColisData.poidsColis!)
            let country = entry.options.colissimoColisData.deliveryAddress!.country!.name
            return "\(country!)\n\(formatColis!) - \(weight!) kg"
        }
        if let product = entry.product {
            return product.descriptor ?? ""
        }
        
        return ""
    }
    
    func showButtonForEntry(index: Int) -> Bool {
        return !self.entry(index).isService()
    }
    
    func isService(index: Int) -> Bool {
        return self.entry(index).isService()
    }
    
    func isColissimo(index: Int) -> Bool {
        return self.entry(index).isColissimo()
    }
    
    func isREEX(index: Int) -> Bool {
        return self.entry(index).isREEX()
    }
    
    func reexProduct(index: Int) -> Product? {
        let produts =  [self.entry(index)].compactMap { (order) -> Product in
            let product = Product()
            let optionReex = OptionReex()
            optionReex.id = order.product.code
            product.name = product.getReexTitle()
            optionReex.price = order.baseNetPrice
            optionReex.startDate = order.options.reexContract.startDate
            optionReex.endDate = order.options.reexContract.endDate
            optionReex.duration = order.options.reexContract.duration as? Int ?? 0
            optionReex.companyName = order.options.reexContract.dhName
            if let theNewAddress = order.options.reexContract.theNewAddress {
                optionReex.newAddress = ReexAddress(street: theNewAddress["adresseL4"] as? String ?? "",
                                                    postalCode: theNewAddress["adresseL6CodeLocalite"] as? String ?? "",
                                                    town: theNewAddress["adresseL6Localite"] as? String ?? "",
                                                    country: (theNewAddress["country"] as? [String: String])?["name"] ?? "")
            }
            if let oldAddress = order.options.reexContract.oldAddress {
                optionReex.originAddress = ReexAddress(street: oldAddress["adresseL4"] as? String ?? "",
                                                       postalCode: oldAddress["adresseL6CodeLocalite"] as? String ?? "",
                                                       town: oldAddress["adresseL6Localite"] as? String ?? "",
                                                       country: (oldAddress["country"] as? [String: String])?["name"] ?? "")
            }
            product.optionReex = optionReex
            return product
        }
        return produts.first
    }
    
    func  priceLabelForEntry(index: Int) -> NSMutableAttributedString {
        let result = NSMutableAttributedString()
        let entry = self.entry(index)
        var price = entry.product.netPrice
        
        if entry.isColissimo() {
            price = entry.options.colissimoColisData.totalNetPriceColis
        }
        
        if price != nil {
            result.custom(price!.formattedValue ?? "0.0", font: UIFont.boldSystemFont(ofSize: 16), color: UIColor.lpPurple)
        }
        if entry.isREEX() {
            result.custom(entry.baseNetPrice, font: UIFont.boldSystemFont(ofSize: 16), color: UIColor.lpPurple)
        } else if !entry.isColissimo() {
            result.custom(" Prix unit. " + entry.product.getTextTax(), font: UIFont.boldSystemFont(ofSize: 14), color: UIColor.lpGrey)
        }
        return result
    }
    
    func quantityForEntry(index:Int) -> String {
        return "x \(self.entry(index).quantity.stringValue)"
    }

    func addressTitle(delivery: Bool) -> String {
        if delivery
        {
            if let deliveryAddress = self.detailOrder?.deliveryAddress {
                var title = deliveryAddress.title
                title = (title == nil ? "" : title! + " ")
                return title! + (deliveryAddress.firstName ?? "")  + " " + (deliveryAddress.lastName ?? "")
            } else {
                return ""
            }
        }
        if let payementAddress = self.detailOrder?.paymentAddress {
            var title = payementAddress.title
            title = (title == nil ? "" : title! + " ")
            return title! + (payementAddress.firstName ?? "") + " " + (payementAddress.lastName ?? "")
        } else if let deliveryAddress = self.detailOrder?.deliveryAddress {
            var title = deliveryAddress.title
            title = (title == nil ? "" : title! + " ")
            return title! +  (deliveryAddress.firstName ?? "")  + " " + (deliveryAddress.lastName ?? "")
        } else {
            return ""
        }
    }
    
    func addressCompanyName(delivery: Bool) -> String {
        if delivery
        {
            if let deliveryAddress = self.detailOrder?.deliveryAddress {
                return (deliveryAddress.companyName ?? "")
            } else {
                return ""
            }
        } else {
            if let payementAddress = self.detailOrder?.paymentAddress {
                return (payementAddress.companyName ?? "")
            } else if let deliveryAddress = self.detailOrder?.deliveryAddress {
                return (deliveryAddress.companyName ?? "")
            } else {
                return ""
            }
        }
        
    }
    
    
    func addressLine1(delivery: Bool) -> String {
        if delivery
        {
            if let deliveryAddress = self.detailOrder?.deliveryAddress {
                return (deliveryAddress.line1 ?? "")
            } else {
                return ""
            }
        } else {
            if let payementAddress = self.detailOrder?.paymentAddress {
                return (payementAddress.line1 ?? "")
            } else if let deliveryAddress = self.detailOrder?.deliveryAddress {
                return (deliveryAddress.line1 ?? "")
            } else {
                return ""
            }
        }
        
    }
    
    func addressLine2(delivery: Bool) -> String {
        if delivery
        {
            if let deliveryAddress = self.detailOrder?.deliveryAddress {
                return ((deliveryAddress.postalCode ?? "") + ", " +  (deliveryAddress.town ?? ""))
            } else {
                return ""
            }
        } else {
            if let payementAddress = self.detailOrder?.paymentAddress{
                return ((payementAddress.postalCode ?? "") + ", " +  (payementAddress.town ?? ""))
            } else if let deliveryAddress = self.detailOrder?.deliveryAddress {
                return ((deliveryAddress.postalCode ?? "") + ", " +  (deliveryAddress.town ?? ""))
            } else {
                return ""
            }
        }
    }

    func addressCountry(delivery: Bool) -> String {
        if delivery
        {
            if let deliveryAddress = self.detailOrder?.deliveryAddress {
                return (deliveryAddress.country?.name ?? "")
            } else {
                return ""
            }
        }
        if let payementAddress = self.detailOrder?.paymentAddress{
            return (payementAddress.country?.name ?? "")
        } else if let deliveryAddress = self.detailOrder?.deliveryAddress {
            return (deliveryAddress.country?.name ?? "")
        } else {
            return ""
        }
    }
    
    func urlImageForEntry(index:Int) -> String? {
        let entry = self.entry(index);
        if let images = entry.product.images as? [HYBImage] {
            for image in images {
                if image.format == "product" {
                    return image.url
                }
            }
        }
        return nil
    }
    
    func reexDetail(index: Int) -> String {
        let optionReex = self.reexProduct(index: index)?.optionReex
        if optionReex?.isDefinitive == true {
            return "\(optionReex?.duration ?? 0) mois"
        } else {
            if let startDate = optionReex?.startDate, let endDate = optionReex?.endDate {
                return "\(startDate.reexDate()) - \(endDate.reexDate())"
            } else {
                return "France - 20g"
            }
        }
    }
    
    func reexImage(index: Int) -> UIImage? {
        if let optionReex = self.reexProduct(index: index)?.optionReex, optionReex.isInternational == true {
            return UIImage(named: "reex-monde")
        } else {
            return UIImage(named: "reex-france")
        }
    }

    private func entry(_ index: Int) -> HYBOrderEntry {
        // Fix product colissimo (assurance, surcout)
        var tmpIndex = -1;
        var indexFinal = -1;
        for entry in (detailOrder!.entries as! [HYBOrderEntry]) {
            if (tmpIndex == index) {
                return detailOrder?.entries[indexFinal] as! HYBOrderEntry
            }
            if !entry.isAttachementColissimo() {
                tmpIndex += 1
            }
            indexFinal += 1
        }
        return detailOrder?.entries[indexFinal] as! HYBOrderEntry
    }
}



