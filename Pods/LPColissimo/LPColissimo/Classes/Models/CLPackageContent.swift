//
//  CLPackageContent.swift
//  LPColissimo
//
//  Created by SPASOV DIMITROV Vladimir on 25/10/18.
//

import Foundation


public struct CLPackageContent : Codable {
    
    public let descriptionArticle : String?
    public let numeroTarifaire : String?
    public let paysOrigine : CLCountryName?
    public let poidsNet : Double?
    public let quantite : Int?
    public let valeurUnitaire : Double?
    
}
