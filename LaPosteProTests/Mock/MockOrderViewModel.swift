//
//  MockOrderViewModel.swift
//  LaPosteProTests
//
//  Created by PENA SANCHEZ Edwin Jose on 17/04/2019.
//  Copyright © 2019 App Mobile. All rights reserved.
//

import XCTest
import LPSharedMCM
@testable import LaPostePro

class MockOrderViewModel: OrderViewModel {
    
    lazy var reexdetailOrder: HYBOrder = {
        let order = HYBOrder()
        let entry = HYBOrderEntry()
        entry?.options = HYBOptions()
        entry?.options.reexContract = HYBReexContract()
        entry?.options.reexContract.startDate = "18/04/2019"
        entry?.options.reexContract.endDate = "31/05/2019"
        entry?.options.reexContract.duration = 0
        entry?.options.reexContract.dhName = "test"
        entry?.options.reexContract.theNewAddress = ["":""]
        entry?.options.reexContract.oldAddress = ["":""]
        entry?.product = HYBProduct()
        entry?.product?.code = "TN_PRO-1_6"
        entry?.product?.name = "Contrat de réexpédition"
        entry?.identifier = "TN_PRO-1_6"
        entry?.baseNetPrice = "66,00 €"
        order?.entries = [entry as Any]
        order?.created = "2019-04-12T08:43:29+0000"
        order?.statusDisplay = "Validée"
        order?.totalPrice = HYBPrice()
        order?.totalPrice.currencyIso = "EUR"
        order?.totalPrice.formattedValue = "66,00 €"
        order?.totalPrice.priceType = "BUY"
        order?.totalPrice.value = 66;
        order?.totalPriceWithTax = HYBPrice()
        order?.totalPriceWithTax.currencyIso = "EUR"
        order?.totalPrice.formattedValue = "66,00 €"
        order?.totalPriceWithTax.priceType = "BUY"
        order?.totalPriceWithTax.value = 66;
        return order!
    }()
    
    func addReexProduct() {
        self.detailOrder = reexdetailOrder
    }

}
