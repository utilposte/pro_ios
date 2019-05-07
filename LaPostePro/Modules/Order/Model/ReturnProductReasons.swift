//
//  ReturOrderReasons.swift
//  LaPostePro
//
//  Created by Issam DAHECH on 20/11/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

struct ReturnProductReasons: Codable {
    var code        : String?
    var motifs      : [ReturnProductReason]?
    var requestType : String?
    var typesProduit: [String]?
}

struct ReturnProductReason: Codable {
    var code                : String?
    var codeMotifScore      : String?
    var famille             : String?
    var libelle             : String?
    var codeProduitScore    : String?
    var codeSource          : String?
    var sousMotifs          : [ReturnProductSubReason]?
}

struct ReturnProductSubReason: Codable {
    var code                : String?
    var codeMotifScore      : String?
    var famille             : String?
    var libelle             : String?
}
