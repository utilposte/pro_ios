//
//  CLGetCartResponse.swift
//  LPColissimo
//
//  Created by SPASOV DIMITROV Vladimir on 24/10/18.
//

import Foundation

public struct CLGetCartResponse : Codable {
    
    public let calculated : Bool?
    public let code : String?
    public let deliveryItemsQuantity : Int?
    public let estimateShipmentDateLabel : String?
    public let guid : String?
    public let hasOnlyEservice : Bool?
    public let net : Bool?
    public let orderDiscounts : CLPriceValue?
    public let pickupItemsQuantity : Int?
    public let productDiscounts : CLPriceValue?
    public let remainingPriceForFreeShipment : Double?
    public let site : String?
    public let store : String?
    public let subTotal : CLPriceValue?
    public let thresholdForFreeShipment : Double?
    public let totalDiscounts : CLPriceValue?
    public let totalItems : Int?
    public let totalNetPrice : CLPriceValue?
    public let totalPrice : CLPriceValue?
    public let totalPriceWithTax : CLPriceValue?
    public let totalTax : CLPriceValue?
    public let totalUnitCount : Int?
    public let type : String?
    
}
