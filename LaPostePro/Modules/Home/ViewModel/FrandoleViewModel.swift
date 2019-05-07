//
//  FrandoleViewModel.swift
//  LaPostePro
//
//  Created by Lassad Tiss on 12/07/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class FrandoleViewModel: NSObject {

    static let sharedInstance = FrandoleViewModel()
    lazy var list = [Frandole]()
    
    func getProducts(for frandoleName: String, onCompletion: @escaping ([Product]?) -> Void) {
        if self.list.isEmpty {
            FrandoleNetworkManager().getFarandoles() { (isSucceded, frandoles) in
                if isSucceded {
                    self.list = frandoles!
                    let frandoles = self.list.filter { $0.name == frandoleName}
                    onCompletion(frandoles.first?.products)
                }
            }
        } else {
            let frandoles = self.list.filter { $0.name == frandoleName}
            onCompletion(frandoles.first?.products)
        }
    }
    
    func getFrandoleProduct(for product: Product) -> Product {
        let thumbnails = product.images!.filter{ $0.format == "thumbnail"}
        if thumbnails.first != nil {
            product.imageUrl = thumbnails.first!.url
        } else {
            if let image: Image = product.images!.first {
                product.imageUrl = image.url
            }
        }
        product.price2 = product.price?.formattedValue
        product.priceType = product.price?.type
        product.detail = "\(product.sendingDestination?.name ?? "") - \(product.weight ?? 0) g"
        return product
    }
    
}
