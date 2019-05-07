//
//  UpdateFormElement.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 21/08/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

struct UpdateFormModel: Codable {
    var companyName: String?
    var companyTypeCode: String?
    var siret: String?
    var tvaIntra: String?
    var serviceCode: String?
    var coclicoClientNumber: String?
    
    var codePostal: String?
    var localite: String?
    var countryCode: String?
    var firstName: String?
    var lastName: String?
    var titleCode: String?
    var numLibelle: String?
    var lieuDit: String?
    var batiment: String?
    var appartement: String?
    var rna: String?
    
    var email: String?
    var telephone : String?
    var pwd: String?
    var checkPwd: String?
    var checkEmail: String?
    var certifiedEtatCode:String?
    var acceptConditions: Bool?
    var time: String?
    var signature: String?
}

struct PasswordModel: Codable {
    var oldPassword: String?
    var newPassword: String?
}

struct EmailModel: Codable {
    var newLogin: String?
    var password: String?
}
