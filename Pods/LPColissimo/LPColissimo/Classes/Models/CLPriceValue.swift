//
//  CLPriceValue.swift
//  LPColissimo
//
//  Created by SPASOV DIMITROV Vladimir on 25/10/18.
//

import Foundation

public struct CLPriceValue : Codable {
    
    public let currencyIso : String?
    public let formattedValue : String?
    public let maxQuantity : Int?
    public let minQuantity : Int?
    public let priceType : String?
    public let value : Double?
    
}


