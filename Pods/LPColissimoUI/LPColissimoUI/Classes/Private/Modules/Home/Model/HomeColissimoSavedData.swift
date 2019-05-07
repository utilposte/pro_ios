//
//  SavedColissimoData.swift
//  LPColissimoUI
//
//  Created by Issam DAHECH on 29/10/2018.
//

import UIKit
import LPColissimo

class ColissimoData {
    
    // MARK: - Singleton
    static var shared: ColissimoData = ColissimoData()
    
    // MARK: - Variables country
    var departureCountry: String?
    var arrivalCountry: String?
    var senderAddress: LPAddressEntity?
    var receiverAddress: LPAddressEntity?
    var selectedSenderAddress: CLCountry?
    var selectedReceiverAddress: CLCountry?
    
    // MARK: - Variables Price
    var price: Double?
    var priceHT: Double?
    
    // MARK: - Variables weight
    var weight: Double?
    var defaultCompensationByWeight: Double?
    
    // MARK: - Variables Delivery and Deposit
    var depositMode: String?
    var deliveryMode: String?
    var insuredValue: Double?
    var withSignature: Bool?
    var indemnitePlus: Bool?
    
    // MARK: - Variables Border Formality
    var articles: [Article] = []
    var sellArticles: [SellArticle] = []
    var otherArticles: [OtherArticle] = []
    var formalityChoice: FormalityChoice?
    var returnReason: String?
    
    var productCodeColis: String?
    var dateDepot: String?
    var totalNetPriceAssurance: Double?
    var totalNetPriceSurcout: Double?
    var dimension: Dimension = .standard
    var isSurcout: Bool? = false
    
    var isOn: Bool = false
    
    public func equal(to: ColissimoDataCopy) -> Bool {
        return self.departureCountry == to.departureCountry
            && self.arrivalCountry == to.arrivalCountry
            && self.senderAddress == to.senderAddress
            && self.receiverAddress == to.receiverAddress
            && self.selectedSenderAddress == to.selectedSenderAddress
            && self.selectedReceiverAddress == to.selectedReceiverAddress
            && self.price == to.price
            && self.priceHT == to.priceHT
            && self.weight == to.weight
            && self.defaultCompensationByWeight == to.defaultCompensationByWeight
            && self.depositMode == to.depositMode
            && self.deliveryMode == to.deliveryMode
            && self.insuredValue == to.insuredValue
            && self.withSignature == to.withSignature
            && self.indemnitePlus == to.indemnitePlus
            && self.articles == to.articles
            && self.sellArticles == to.sellArticles
            && self.otherArticles == to.otherArticles
            && self.formalityChoice?.code == to.formalityChoice?.code
            && self.returnReason == to.returnReason
            && self.productCodeColis == to.productCodeColis
            && self.dateDepot == to.dateDepot
            && self.totalNetPriceAssurance == to.totalNetPriceAssurance
            && self.totalNetPriceSurcout == to.totalNetPriceSurcout
            && self.dimension == to.dimension
            && self.isSurcout == to.isSurcout
            && self.isOn == to.isOn
    }
    
    func containsFormalities() -> Bool {
        return self.articles.isEmpty && self.sellArticles.isEmpty && self.otherArticles.isEmpty
    }
}

class ColissimoDataCopy {
    // MARK: - Singleton
    static var shared: ColissimoDataCopy = ColissimoDataCopy()
    
    // MARK: - Variables country
    var departureCountry: String?
    var arrivalCountry: String?
    var senderAddress: LPAddressEntity?
    var receiverAddress: LPAddressEntity?
    var selectedSenderAddress: CLCountry?
    var selectedReceiverAddress: CLCountry?
    
    // MARK: - Variables Price
    var price: Double?
    var priceHT: Double?
    
    // MARK: - Variables weight
    var weight: Double?
    var defaultCompensationByWeight: Double?
    
    // MARK: - Variables Delivery and Deposit
    var depositMode: String?
    var deliveryMode: String?
    var insuredValue: Double?
    var withSignature: Bool?
    var indemnitePlus: Bool?
    
    // MARK: - Variables Border Formality
    var articles: [Article] = []
    var sellArticles: [SellArticle] = []
    var otherArticles: [OtherArticle] = []
    var formalityChoice: FormalityChoice?
    var returnReason: String?
    
    var productCodeColis: String?
    var dateDepot: String?
    var totalNetPriceAssurance: Double?
    var totalNetPriceSurcout: Double?
    var dimension: Dimension = .standard
    var isSurcout: Bool? = false
    
    var isOn: Bool = false
    
    func containsFormalities() -> Bool {
        return self.articles.isEmpty && self.sellArticles.isEmpty && self.otherArticles.isEmpty
    }
    
    func copy(from: ColissimoData) {
        self.departureCountry = from.departureCountry
        self.arrivalCountry = from.arrivalCountry
        self.senderAddress = from.senderAddress
        self.receiverAddress = from.receiverAddress
        self.selectedSenderAddress = from.selectedSenderAddress
        self.selectedReceiverAddress = from.selectedReceiverAddress
        self.price = from.price
        self.priceHT = from.priceHT
        self.weight = from.weight
        self.defaultCompensationByWeight = from.defaultCompensationByWeight
        self.depositMode = from.depositMode
        self.deliveryMode = from.deliveryMode
        self.insuredValue = from.insuredValue
        self.withSignature = from.withSignature
        self.indemnitePlus = from.indemnitePlus
        self.articles = from.articles
        self.sellArticles = from.sellArticles
        self.otherArticles = from.otherArticles
        self.formalityChoice?.code = from.formalityChoice?.code ?? ""
        self.returnReason = from.returnReason
        self.productCodeColis = from.productCodeColis
        self.dateDepot = from.dateDepot
        self.totalNetPriceAssurance = from.totalNetPriceAssurance
        self.totalNetPriceSurcout = from.totalNetPriceSurcout
        self.dimension = from.dimension
        self.isSurcout = from.isSurcout
        self.isOn = from.isOn
    }
}
