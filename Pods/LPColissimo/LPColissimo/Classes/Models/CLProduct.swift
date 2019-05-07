//
//  CLProduct.swift
//  LPColissimo
//
//  Created by SPASOV DIMITROV Vladimir on 25/10/18.
//

import Foundation

public struct CLProduct : Codable {
    
    public let availableForPickup : Bool?
    public let code : String?
    public let descriptionField : String?
    public let modulo : Bool?
    public let name : String?
    public let purchasable : Bool?
    public let stock : CLStock?
    public let url : String?
}

public struct CLStock : Codable {
    
    public let stockLevelStatus : String?
    
}
