//
//  ReturnOrderModel.swift
//  LaPostePro
//
//  Created by Issam DAHECH on 20/11/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import Foundation

struct ReturnOrderModel: Codable {
    // Data To show
    
    enum ErrorType :  Int {
        case reason
        case subReason
        case description
    }
    
    var errorType = [ErrorType]()
    
    var refLabel = ""
    var nameProduct = ""
    var detailsProduct = ""
    var maxProducts = 1
    var quantity = 1
    var isSelected = false
    var isPhysicalProduct = true
    var reasons : [ReturnProductReason]?
    var currentReason : ReturnProductReason?
    var currentSubReason : ReturnProductSubReason?
    
    // Data To Send
    var requestType = "Return"
    var roleReclamant = "Destinataire" // A voir avec le CP / PO !!
    
    var numcommande = ""
    var entryNumber = ""
    
    var returnedQuantity = ""
    var description = ""
    
    
    // MOTIF
    var source = ""
    var famille = ""
    var produit = "" // codeProduitScore
    var motif = "" // codeMotifScore
    var sousmotif = "" // codeSousMotifScore
    var infocomplementaire = "" // Vide
    var numprocuration = "" // Vide
    var numcontrat = "" // Vide
    var numfacture = "" // Vide
    var numobjetinter = "" // Vide
    var numobjetfrance = "" // Vide
    
    private enum CodingKeys: String, CodingKey {
        case requestType
        case returnedQuantity
        case entryNumber
        case source
        case roleReclamant
        case famille
        case produit
        case motif
        case sousmotif
        case description
        case infocomplementaire
        case numprocuration
        case numcontrat
        case numfacture
        case numcommande
        case numobjetinter
        case numobjetfrance
    }
    
    func setReason() {
        
    }
}


//"requestType" : "Return",
//"returnedQuantity" : "1",
//"entryNumber" : "0",
//"source": "SO-12",
//"roleReclamant": "Destinataire",
//"famille": "Demande client",
//"produit": "OBJ183",
//"motif": "MOT145",
//"description": "test description blabla Information1",
//"infocomplementaire" : "test infocomplementaire",
//"numprocuration" : "test",
//"numcontrat" : "test",
//"numfacture" : "test",
//"numcommande" : "88483000",
//"numobjetinter" : "test",
//"numobjetfrance" : "test"
