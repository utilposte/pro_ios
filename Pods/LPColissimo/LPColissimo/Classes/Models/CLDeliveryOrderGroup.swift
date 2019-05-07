//
//  CLDeliveryOrderGroup.swift
//  LPColissimo
//
//  Created by SPASOV DIMITROV Vladimir on 25/10/18.
//

import Foundation

public struct CLDeliveryOrderGroup : Codable {
    
    public let entries : [CLEntry]?
    public let totalPriceWithTax : CLPriceValue?
}
