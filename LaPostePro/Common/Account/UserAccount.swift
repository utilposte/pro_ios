//
//  UserAccount.swift
//  LaPostePro
//
//  Created by Matthieu Lemonnier on 17/08/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class UserAccount: NSObject {

    @objc static let shared = UserAccount()
    
    var accessToken : String?
    var customerInfo : CustomerInfo?

    func userAccountToDataModel() -> UpdateFormModel {
        var dataModel = UpdateFormModel()
        dataModel.email = UserAccount.shared.customerInfo?.displayUid
        dataModel.codePostal = UserAccount.shared.customerInfo?.defaultAddress?.postalCode
        dataModel.companyName = UserAccount.shared.customerInfo?.defaultAddress?.companyName
        dataModel.companyTypeCode = UserAccount.shared.customerInfo?.companyTypeCode
        dataModel.countryCode = UserAccount.shared.customerInfo?.defaultAddress?.country?.isocode
        dataModel.firstName = UserAccount.shared.customerInfo?.firstName
        dataModel.lastName = UserAccount.shared.customerInfo?.lastName
        dataModel.localite = UserAccount.shared.customerInfo?.defaultAddress?.town
        dataModel.numLibelle = UserAccount.shared.customerInfo?.defaultAddress?.line2
        dataModel.telephone = UserAccount.shared.customerInfo?.phone
        dataModel.siret = UserAccount.shared.customerInfo?.siret
        dataModel.rna = UserAccount.shared.customerInfo?.rna
        
        dataModel.tvaIntra = UserAccount.shared.customerInfo?.tvaIntra
        dataModel.titleCode = UserAccount.shared.customerInfo?.titleCode
        dataModel.certifiedEtatCode = UserAccount.shared.customerInfo?.certifiedEtatCode
        return dataModel
    }
}

class ConnectionResponse : Codable {
    var accessToken : AccessTocken?
    var customerInfo : CustomerInfo?
    
    enum CodingKeys: String, CodingKey {
        case accessToken
        case customerInfo = "ebkCustomerProWsDTO"
    }
}

class AccessTocken: Codable {
    var accessToken: String?
    var expiresIn: Int?
    var refreshToken: String?
    var tokenType: String?
}

class CustomerInfo : Codable {
    var displayUid : String?
    var firstName : String?
    var lastName : String?
    var titleCode : String?
    var coclicoClientNumber : String?
    var companyName : String?
    var companyTypeCode : String?
    var companyTypeName : String?
    var functionCode : String?
    var phone : String?
    var siret : String?
    var tvaIntra : String?
    var serviceCode: String?
    var rna: String?
    
    var defaultAddress : AccountAddress?
    var isCustomerProCertified : Bool?
    var certifiedEtatCode : String?
    var currency : IsoCode?
    var language : IsoCode?
    var customerId : String?
    
    enum CodingKeys: String, CodingKey {
        case displayUid
        case firstName
        case lastName
        case titleCode
        case coclicoClientNumber
        case companyName
        case companyTypeCode
        case companyTypeName
        case functionCode
        case phone
        case siret
        case tvaIntra
        case serviceCode
        case rna
        case defaultAddress
        case certifiedEtatCode
        case isCustomerProCertified
        case currency
        case language
        case customerId
    }
    
    func showCertified() -> Bool{
        return self.certifiedEtatCode != "waiting-for-documents"
    }
    
    func isCertified() -> Bool {
        return self.certifiedEtatCode == "certified"
    }
    
    func getStatusFrom() -> String {
        var result = "Non Certifié"
        
        switch certifiedEtatCode {
        case "being-certified","waiting-for-update":
            result = "Actualisation en cours"
        case "uncertified":
            result = "Non Certifié"
        case "certified":
            result = "Certifié"
        case "waiting-for-documents":
            result = "En attente de document"
        default:
            result = "Non Certifié"
        }
        return result
    }
}

class IsoCode : Codable {
    var isocode : String?
    var name : String?
}

class AccountAddress: Codable {
    var companyName : String?
    var formattedAddress : String?
    var line1 : String?
    var line2 : String?
    var postalCode : String?
    var streetNumber : String?
    var title : String?
    var titleCode : String?
    var town : String?
    var country : IsoCode?
}

class ErrorWS : Codable {
    var errors : [ErrorDetailWS?]?
    var ebkCustomerProWsDTO : EbkCustomerProWsDTO?
}

class EbkCustomerProWsDTO : Codable {
    var dateFermeture : String?
    var dateFinActivite : String?
    var dateInactivation : String?
    var siret : String?
    var rna : String?
}

class ErrorDetailWS : Codable {
    var codeError : String?
    var message : String?
    var type : String?
}
