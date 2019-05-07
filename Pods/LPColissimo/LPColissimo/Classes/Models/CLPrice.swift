//
//  CLPrice.swift
//  LPColissimo
//
//  Created by Khaled El Abed on 05/10/2018.
//

import UIKit

public struct CLPrice: Codable {
    public var assuranceLabel: String
    public var assuranceTotal: Double
    public var assuranceTypeRecommande: String?
    public var avecSignature: Bool
    public var prixHT: Double
    public var productCodeAssurance: String?
    public var productCodeColis: String
    public var productCodeSurcout: String?
    public var surcout: Double
    public var totalHT: Double
    public var weight: Double
}
