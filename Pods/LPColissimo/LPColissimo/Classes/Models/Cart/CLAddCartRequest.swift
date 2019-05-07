//
//  CLAddCartRequest.swift
//  LPColissimo
//
//  Created by SPASOV DIMITROV Vladimir on 25/10/18.
//

import Foundation


public struct CLAddCartRequestData : Codable {
    
    public let listColissimo : [CLPackageData]?
    
}

public struct CLPackageData : Codable {
    
    public let avecAssurance : Bool?
    public let avecSiganture : Bool?
    public let colisRegime : String?
    public let dateDepot : String?
    public let deliveryAddress : CLAdress?
    public let emailDestinataire : String?
    public let expediteurAddress : CLAdress?
    public let formalitesDouaniere : CLCustomsFormalities?
    public let fromIsoCode : String?
    public let id : String?
    public let indemnitePlus : Bool?
    public let insuredValue : Int?
    public let labelAssuranceColis : String?
    public let livraisonAvecSignature : Bool?
    public let modeDepot : String?
    public let modeLivraison : String?
    public let nameColisFavoris : String?
    public let originalId : String?
    public let poidsColis : Int?
    public let recommendationLevel : String?
    public let refColis : String?
    public let suiviEmail : [String]?
    public let toIsoCode : String?
    public let totalNetPriceAssurance : CLPriceValue?
    public let totalNetPriceColis : CLPriceValue?
    public let totalNetPriceSurcout : CLPriceValue?
    public let typeColis : String?
    public let typeSupplColis : String?
}


