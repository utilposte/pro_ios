//
//  CLCartWsDTO.swift
//  LPColissimo
//
//  Created by SPASOV DIMITROV Vladimir on 25/10/18.
//

import Foundation


public struct CLCartWsDTO : Codable {
    
    public let calculated : Bool?
    public let code : String?
    public let deliveryItemsQuantity : Int?
    public let deliveryOrderGroups : [CLDeliveryOrderGroup]?
    public let entries : [CLEntry]?
    public let estimateShipmentDateLabel : String?
    public let guid : String?
    public let net : Bool?
    public let orderDiscounts : CLPriceValue?
    public let pickupItemsQuantity : Int?
    public let productDiscounts : CLPriceValue?
    public let remainingPriceForFreeShipment : Int?
    public let site : String?
    public let store : String?
    public let subTotal : CLPriceValue?
    public let thresholdForFreeShipment : Int?
    public let totalDiscounts : CLPriceValue?
    public let totalItems : Int?
    public let totalNetPrice : CLPriceValue?
    public let totalPrice : CLPriceValue?
    public let totalPriceWithTax : CLPriceValue?
    public let totalTax : CLPriceValue?
    public let totalUnitCount : Int?
    
}
