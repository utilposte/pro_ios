//
//  CLDeliveryModeResponse.swift
//  LPColissimo
//
//  Created by SPASOV DIMITROV Vladimir on 24/10/18.
//

import Foundation

public struct CLDeliveryModeResponse : Codable {
    
    public let indemnisationBoite : CLIndemnisation?
    public let indemnisationMainPropre : CLIndemnisation?
    public let isPossibleLivraisonBoite : Bool?
    public let isPossibleLivraisonMainPropre : Bool?
}

public struct CLIndemnisation : Codable {
    
    public let max : Double?
    public let min : Double?
}

