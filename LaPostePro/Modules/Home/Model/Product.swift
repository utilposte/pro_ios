//
//  Product.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 14/05/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import Foundation
import LPSharedMCM

struct SendingDestination: Codable {
    
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case name = "label"
    }
}

struct Image: Codable {
    
    var url: String
    var type: String
    var format: String
    
    enum CodingKeys: String, CodingKey {
        case url
        case type = "imageType"
        case format
    }
}

struct Price: Codable {
    var currency: String
    var formattedValue: String
    var type: String
    var value: Float
    
    enum CodingKeys: String, CodingKey {
        case currency = "currencyIso"
        case formattedValue
        case type = "priceType"
        case value
    }
}

class OptionColissimo {
    var countryRecipient : String?
    var weight : String?
    var totalNetPriceColis : String?
    var formatColis : String?
    var deliveryMode: String?
    var shippingMode: String?
    var senderAddress: HYBAddress?
    var receiverAddress: HYBAddress?
}

enum ContractReex {
    case office
    case online
    case other
    
    var title: String {
        switch self {
        case .office:
            return "En bureau de poste"
        case .online:
            return "En ligne"
        case .other:
            return "Autres"
        }
    }
    
    var image: String {
        switch self {
        case .office:
            return "PostOfficeReex"
        case .online:
            return "OnlineReex"
        case .other:
            return "OtherReex"
        }
    }
}

class OptionReex {
    var id: String?
    var startDate: String?
    var endDate: String?
    var duration: Int = 0
    var price: String?
    var originAddress: ReexAddress?
    var newAddress: ReexAddress?
    var companyName: String?
    var contractActivation: ContractReex?
    var isInternational: Bool = false
    var isDefinitive: Bool = false
}

class ReexAddress {
    var street: String?
    var postalCode: String?
    var town: String?
    var country: String?
    
    init(street: String, postalCode: String, town: String, country:String) {
        self.street = street
        self.postalCode = postalCode
        self.town = town
        self.country = country
    }
}

class Product: Codable {
    var id: String?
    var name: String?
    var imageUrl: String?
    var detail: String?
    var price: Price?
    var price2: String?
    var netPrice: Price?
    var netPrice2: String?
    
    var baseNetPrice : String?
    
    var taxClass: String?
    var priceType: String?
    var quantityInCart: NSNumber?
    var sendMode: String?
    var weightAndDestinationText: String?
    var categoryName: String?
    var availabilityLabel: AvailabilityLabel?
    var imagesUrlList: [String]?
    var degressivity: String?
    var isAvailable: Bool?
    var totalNetPrice : String?
    var totalPrice : String?
    var delaiEnvoi : String?
    
    // Carousel cross sale - Frandole product
    var weight: Int?
    var sendingDestination: SendingDestination?
    var images: [Image]?
    var frandolePrice: Price?
    
    // Entry Information
    var entryNumber : Int?
    
    // Colissimo
    var optionColissimo : OptionColissimo?
    var optionReex: OptionReex?
    
    
    enum CodingKeys: String, CodingKey {
        case id = "code"
        case name
        case weight = "poidsMaxEnvoi"
        case sendingDestination = "destinationEnvoi"
        case images
        case price
        //case frandolePrice = "price"
        case imageUrl
        case detail
        
        case price2
        case netPrice
        case netPrice2
        case taxClass
        case priceType
//        case quantityInCart
        case sendMode
        case weightAndDestinationText
        case categoryName
        case imagesUrlList
        case degressivity
        case isAvailable
        case totalNetPrice
        
        case baseNetPrice
    }
}


extension Product: Equatable {

    convenience init(name: String, imageUrl: String, detail: String) {
        self.init()
        self.name = name
        self.imageUrl = imageUrl
        self.detail = detail
    }

    convenience init(hybProduct: HYBProduct) {
        self.init()
        self.id = hybProduct.code
        self.name = hybProduct.name
        self.imageUrl = hybProduct.imageURL
        if hybProduct.destinationEnvoi != nil && hybProduct.destinationEnvoi.label != nil {
             self.detail = String(format: "%@ - %@", hybProduct.destinationEnvoi.label, hybProduct.getWeight())
        }
        if let price = hybProduct.price {
            self.price2 = price.formattedValue
            
        }
        if let price = hybProduct.netPrice {
            self.netPrice2 = price.formattedValue
        }
        if let price = hybProduct.price {
            self.price = Price(currency: price.currencyIso, formattedValue: price.formattedValue, type: price.priceType, value: Float(price.value))
        }
        
        if let price = hybProduct.netPrice {
            self.netPrice = Price(currency: price.currencyIso, formattedValue: price.formattedValue, type: price.priceType, value: Float(price.value))
        }
        
        if let price = hybProduct.price, let priceType = price.priceType {
            self.priceType = priceType
        }
        if hybProduct.delaiEnvoi != nil {
            self.sendMode = hybProduct.delaiEnvoi.label
        }
        if hybProduct.destinationEnvoi != nil {
            self.weightAndDestinationText = hybProduct.destinationEnvoi.label
        }
        if hybProduct.getWeight() != nil && self.weightAndDestinationText != nil {
            self.weightAndDestinationText = String(format: "%@ - %@", self.weightAndDestinationText!, hybProduct.getWeight())
        } else if hybProduct.getWeight() != nil && self.weightAndDestinationText == nil {
            self.weightAndDestinationText = hybProduct.getWeight()
        }        
        self.imageUrl = hybProduct.imageURL
        if (hybProduct.stock.stockLevelStatus != nil) {
            self.availabilityLabel = getAvailabelity(level: hybProduct.stock.stockLevelStatus!)
        }
        imagesUrlList = [String]()
        if let images = hybProduct.images {
            for hybImage in images {
                imagesUrlList!.append((hybImage as! HYBImage).url)
            }
            imagesUrlList = imagesUrlList?.reversed()
        }
        if hybProduct.volumePricesFlag {
            degressivity = Constants.degressivityText
        } else {
            degressivity = ""
        }
        if hybProduct.delaiEnvoi != nil {
            if hybProduct.delaiEnvoi.label != nil {
                self.delaiEnvoi = hybProduct.delaiEnvoi.label
            }
        }
        
        isAvailable = setIsAvailable(level: hybProduct.stock.stockLevelStatus!)
        self.taxClass = hybProduct.getTextTax()
    }

    convenience init(hybEntry: HYBOrderEntry) {
        self.init(hybProduct: hybEntry.product)
        self.quantityInCart = hybEntry.quantity
        self.entryNumber = hybEntry.entryNumber.intValue
        
        if let baseNetPrice = hybEntry.baseNetPrice {
            self.baseNetPrice = baseNetPrice
        }
        
        if hybEntry.totalNetPrice != nil {

            if let totalNetPrice = hybEntry.totalNetPrice.formattedValue {
                self.totalNetPrice = totalNetPrice
            }

        }

        if hybEntry.totalPrice != nil {
            if let totalPrice = hybEntry.totalPrice.formattedValue {
                self.totalPrice = totalPrice
            }
        }
        
        if hybEntry.isColissimo(), hybEntry.options != nil {
            self.optionColissimo = OptionColissimo()
            self.optionColissimo!.formatColis = hybEntry.options.colissimoColisData.typeColis
            if self.optionColissimo!.formatColis == "ROULEAU" {
                self.optionColissimo!.formatColis = "TUBE"
            }
            self.optionColissimo!.countryRecipient = hybEntry.options.colissimoColisData.deliveryAddress!.country!.name
            self.optionColissimo!.totalNetPriceColis = hybEntry.options.colissimoColisData.totalNetPriceColis!.formattedValue
            
            self.optionColissimo!.deliveryMode = hybEntry.options.colissimoColisData.modeDepot
            self.optionColissimo!.shippingMode = hybEntry.options.colissimoColisData.modeLivraison
            
            self.optionColissimo!.senderAddress = hybEntry.options.colissimoColisData.expediteurAddress
            self.optionColissimo!.receiverAddress = hybEntry.options.colissimoColisData.deliveryAddress
            
            let nf = NumberFormatter()
            nf.maximumFractionDigits = 3
            nf.minimumFractionDigits = 3
            nf.minimumIntegerDigits = 1
            self.optionColissimo!.weight = nf.string(from: hybEntry.options.colissimoColisData.poidsColis!)
        }
        
        if hybEntry.isREEX() {
            self.optionReex = OptionReex()
            self.optionReex?.id = hybEntry.identifier
            if let duration = hybEntry.options.reexContract.duration {
                self.optionReex?.duration = Int(truncating: duration)
            }
            self.optionReex?.startDate = hybEntry.options.reexContract.startDate
            self.optionReex?.endDate = hybEntry.options.reexContract.endDate
            self.optionReex?.price = hybEntry.basePrice.formattedValue
            self.optionReex?.companyName = hybEntry.options.reexContract.dhName
            var oldAddressCountry = hybEntry.options.reexContract.oldAddress["country"] as! [String: String]
            
            // ADDRESSES
            self.optionReex?.originAddress = ReexAddress.init(
                street: hybEntry.options.reexContract.oldAddress["adresseL4"] as! String,
                postalCode: hybEntry.options.reexContract.oldAddress["adresseL6CP"] as! String,
                town: hybEntry.options.reexContract.oldAddress["adresseL6Localite"] as! String,
                country: oldAddressCountry["name"] ?? "")
            
            var newAddressCountry = hybEntry.options.reexContract.theNewAddress["country"] as! [String: String]
            
            self.optionReex?.newAddress = ReexAddress.init(
                street: hybEntry.options.reexContract.theNewAddress["adresseL4"] as! String,
                postalCode: hybEntry.options.reexContract.theNewAddress["adresseL6CP"] as! String,
                town: hybEntry.options.reexContract.theNewAddress["adresseL6Localite"] as! String,
                country: newAddressCountry["name"] ?? "")
            
            switch (hybEntry.options.reexContract.bdpActivation, hybEntry.options.reexContract.onlineActivation) {
            case (false, true):
                self.optionReex?.contractActivation = ContractReex.online
            case (true, false):
                self.optionReex?.contractActivation = ContractReex.office
            case (false, false):
                self.optionReex?.contractActivation = ContractReex.other
            default:
                self.optionReex?.contractActivation = ContractReex.other
            }
        }
    }
    
    internal func productToHYBProduct(dictionary: [AnyHashable: Any]!) -> Product {
        let hybProduct = HYBProduct(params: dictionary)
        let product = Product.init(hybProduct: hybProduct!)
        return product
    }

    private func getAvailabelity(level: String) -> AvailabilityLabel {
        switch level {
        case "inStock":
            return AvailabilityLabel.init(text: "", color: .clear, height: 16)
        case "lowStock":
            return AvailabilityLabel.init(text: Constants.lowStockProductText, color: UIColor.lpRedForUnavailableProduct, height: 16)
        case "outOfStock":
            return AvailabilityLabel.init(text: Constants.notAvailableProductText, color: UIColor.lpRedForUnavailableProduct, height: 16)
        default:
            return AvailabilityLabel.init(text: "", color: .clear, height: 16)
        }
    }
    
    func isColissimo() -> Bool {
        return self.optionColissimo != nil
    }
    
    func isReex() -> Bool {
        return self.optionReex != nil
    }
    
    func getDeliveryModeString() -> String? {
        guard let deliveryMode = self.optionColissimo?.deliveryMode else {
            return nil
        }
        if deliveryMode == "BUREAU_POSTE" {
            return "En bureau de poste"
        } else {
            return "En boite aux lettres"
        }
    }
    
    func getShippingModeString() -> String? {
        guard let shippingMode = self.optionColissimo?.shippingMode else {
            return nil
        }
        if shippingMode == "BOITE_LETTRE" {
            return "En boite aux lettres"
        } else {
            return "En main propre"
        }
    }

    func getReexTitle() -> String? {
        if self.isReex() {
            switch self.optionReex?.id?.prefix(2) {
            case "TI":
                self.optionReex?.isInternational = true
                self.optionReex?.isDefinitive = false
                return "Contrat de réexpédition temporaire internationale"
            case "DI":
                self.optionReex?.isInternational = true
                self.optionReex?.isDefinitive = true
                return "Contrat de réexpédition définitive internationale"
            case "TN":
                self.optionReex?.isInternational = false
                self.optionReex?.isDefinitive = false
                return "Contrat de réexpédition temporaire nationale"
            case "DN":
                self.optionReex?.isInternational = false
                self.optionReex?.isDefinitive = true
                return "Contrat de réexpédition définitive nationale"
            default:
                self.optionReex?.isInternational = false
                self.optionReex?.isDefinitive = false
                return "Contrat de réexpédition"
            }
        } else {
            self.optionReex?.isInternational = false
            self.optionReex?.isInternational = false
            return "Contrat de réexpédition"
        }
    }

    fileprivate func setIsAvailable(level: String) -> Bool {
        switch level {
        case "outOfStock":
            return false
        default:
            return true
        }
    }
    
    static func ==(lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id
    }
}
