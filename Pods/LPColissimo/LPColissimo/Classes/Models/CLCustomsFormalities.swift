//
//  CLCustomsFormalities.swift
//  LPColissimo
//
//  Created by SPASOV DIMITROV Vladimir on 25/10/18.
//

import Foundation

public struct CLCustomsFormalities : Codable {
    
    public let code : String?
    public let contenusColis : [CLPackageContent]?
    public let natureEnvoi : CLContentsNature?
    public let returnReason : String?
    
}
