//
//  CLEntry.swift
//  LPColissimo
//
//  Created by SPASOV DIMITROV Vladimir on 25/10/18.
//

import Foundation

public struct CLEntry : Codable {
    
    public let basePrice : CLPriceValue?
    public let codeUniqueColis : String?
    public let entryNumber : Int?
    public let id : String?
    public let options : CLOption?
    public let product : CLProduct?
    public let productType : String?
    public let quantity : Int?
//    public let statusPhila : StatusPhila?
    public let totalPrice : CLPriceValue?
    public let updateable : Bool?
}

public struct CLOption : Codable {
    
    public let colissimoColisData : CLColisData?

}
