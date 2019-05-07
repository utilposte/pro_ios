//
//  AccengageTaggingManager.swift
//  LaPostePro
//
//  Created by Lassad Tiss on 19/09/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import Accengage

class AccengageTaggingManager: NSObject {

    func getItem(for product: Product) -> ACCCartItem {
        let id = product.id
        let name = product.name
        let brand = ""
        let category = product.categoryName ?? ""
        var _price = 0.0
        if let price = product.price?.value {
            _price = Double(price)
        } else {
            _price = 0.0
        }
        let quantity = Int(truncating: product.quantityInCart ?? 1)
        
        let item = ACCCartItem.init(id: id!, name: name, brand: brand, category: category, price: _price, quantity:  quantity)
        return item
    }
    
    func trackAddToCart (product: Product){
        Accengage.trackCart("cart_Id", currency: "EUR", item: getItem(for: product))
    }
    
    func trackPurchase (order: [Product]){
        if order.count > 0 {
            var items : [ACCCartItem] = []
            let numEntries = order.count - 1
            for i in 0...numEntries {
                items.append(getItem(for: order[i]))
            }
            Accengage.trackPurchase(String(arc4random_uniform(10000) + 1), currency: "EUR", items: items, amount: nil)
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
            let currentDate = formatter.string(from: Date())
            Accengage.updateDeviceInfo(["date_dernier_achat": currentDate])
        }
    }
    
    func trackCustomer (id: String){
        Accengage.updateDeviceInfo(["id_client": id])
    }
    
}
