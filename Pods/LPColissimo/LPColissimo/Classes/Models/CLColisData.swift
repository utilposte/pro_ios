//
//  CLColisData.swift
//  LPColissimo
//
//  Created by SPASOV DIMITROV Vladimir on 25/10/18.
//

import Foundation
import LPSharedMCM

public struct CLColisData : Codable {
    
    public let avecAssurance : Bool?
    public let colisRegime : String?
    public let dateDepot : String?
    public let deliveryAddress : CLAdress?
    public let expediteurAddress : CLAdress?
    public let formalitesDouaniere : CLCustomsFormalities?
    public let fromIsoCode : String?
    public let indemnitePlus : Bool?
    public let insuredValue : Double?
    public let labelAssuranceColis : String?
    public let modeDepot : String?
    public let modeLivraison : String?
    public let poidsColis : Double?
    public let refColis : String?
    public let toIsoCode : String?
    public let totalNetPriceAssurance : CLPriceValue?
    public let totalNetPriceColis : CLPriceValue?
    public let totalNetPriceSurcout : CLPriceValue?
    public let typeColis : String?
    
}

//public class CLColisData : Codable/*, MTLModel, MTLJSONSerializing*/ {
//    public static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
//        return [
//            "avecAssurance" : "avecAssurance",
//            "colisRegime" : "colisRegime",
//            "dateDepot" : "dateDepot",
//            "deliveryAddress" : "deliveryAddress",
//            "expediteurAddress" : "expediteurAddress",
//            "formalitesDouaniere" : "formalitesDouaniere",
//            "fromIsoCode" : "fromIsoCode",
//            "indemnitePlus" : "indemnitePlus",
//            "insuredValue" : "insuredValue",
//            "labelAssuranceColis" : "labelAssuranceColis",
//            "modeDepot" : "modeDepot",
//            "modeLivraison" : "modeLivraison",
//            "poidsColis" : "poidsColis",
//            "refColis" : "refColis",
//            "toIsoCode" : "toIsoCode",
//            "totalNetPriceAssurance" : "totalNetPriceAssurance",
//            "totalNetPriceColis" : "totalNetPriceColis",
//            "totalNetPriceSurcout" : "totalNetPriceSurcout",
//            "typeColis" : "typeColis"
//        ]
//    }


//    public let avecAssurance : Bool?
//    public let colisRegime : String?
//    public let dateDepot : String?
//    public let deliveryAddress : HYBAddress?
//    public let expediteurAddress : CLAdress?
//    public let formalitesDouaniere : CLCustomsFormalities?
//    public let fromIsoCode : String?
//    public let indemnitePlus : Bool?
//    public let insuredValue : Int?
//    public let labelAssuranceColis : String?
//    public let modeDepot : String?
//    public let modeLivraison : String?
//    public let poidsColis : Int?
//    public let refColis : String?
//    public let toIsoCode : String?
//    public let totalNetPriceAssurance : CLPriceValue?
//    public let totalNetPriceColis : CLPriceValue?
//    public let totalNetPriceSurcout : CLPriceValue?
//    public let typeColis : String?

//}
