//
//  CLDepotModeResponse.swift
//  Pods
//
//  Created by SPASOV DIMITROV Vladimir on 24/10/18.
//

import Foundation


public struct CLDepotModeResponse : Codable {
    
    public let basculeToSecondeDate : Bool?
    public let basculeToSecondeDateMsg: String?
    public let date : [CLDateDepot]?
    public let secondDate:CLDateDepot?
    
}

public struct CLDateDepot : Codable {
    
    public let id : String?
    public let label : String?
}
