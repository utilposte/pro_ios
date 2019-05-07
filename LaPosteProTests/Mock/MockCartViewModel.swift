//
//  MockCartViewModel.swift
//  LaPosteProTests
//
//  Created by PENA SANCHEZ Edwin Jose on 16/04/2019.
//  Copyright © 2019 App Mobile. All rights reserved.
//

import XCTest
import LPSharedMCM
@testable import LaPostePro

class MockCartViewModel: CartViewModel {
    
    var addReexProduct: Bool = false
    lazy var reexProduct: Product = {
        let product = Product()
        product.id = "TN_PRO-1_6"
        product.name = "Réexpédition temporaire nationale"
        product.baseNetPrice = "66,00 €"
        product.taxClass = "HT"
        product.quantityInCart = 1
        product.weightAndDestinationText = "50 g"
        product.isAvailable = true
        product.totalNetPrice = "66,00 €"
        product.totalPrice = "66,00 €"
        product.entryNumber = 0
        product.optionReex = OptionReex()
        product.optionReex?.id = "TN_PRO-1_658ceb65e-2aee-4ef9-973b-abee21f75287"
        product.optionReex?.startDate =  "20/04/2019"
        product.optionReex?.endDate = "31/05/2019"
        product.optionReex?.duration = 0
        product.optionReex?.price = "66,00 €"
        product.optionReex?.originAddress = ReexAddress(street: "Rue 1", postalCode: "93130", town: "Paris", country: "France")
        product.optionReex?.newAddress = ReexAddress(street: "Rue 2", postalCode: "93130", town: "Paris", country: "France")
        product.optionReex?.companyName = "test1"
        product.optionReex?.contractActivation = .other
        product.optionReex?.isInternational = false
        product.optionReex?.isDefinitive = false
        return product
    }()
    
    override func getCart(onCompletion: @escaping (HYBCart) -> Void) {
        let cartModel = HYBCart()
        cartModel?.totalUnitCount = 1
        
        // Add Reex Product
        if addReexProduct == true {
           self.products.append(self.reexProduct)
        }
        
        onCompletion(cartModel!)
    }
    
    
    override func getProductListForCarousel(query: String, completion: (@escaping ([HYBProduct]) -> Void)) {
        completion([])
    }
}
