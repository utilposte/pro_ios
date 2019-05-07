//
//  PostOfficePro.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 15/04/2019.
//  Copyright © 2019 App Mobile. All rights reserved.
//

import UIKit

class PostOfficesPro: Codable {
    var bureaux: [PostOfficePro]
}

class PostOfficePro: Codable {
    var codeRoc: String?
    var libelleSite: String?
    var numVoieGeo: String?
    var libelleVoiePostale: String?
    var adresse: String?
    var codePostal: String?
    var lng: String?
    var lat: String?
    var libelleCommuneGeo: String?
    var localite: String?
    var telephoneIndigo: String?
    var tarif: String?
    var etat: PostOfficeProState?
}

class PostOfficeProState: Codable {
    var date: String?
    var ouvert: Bool?
    var dateChangement: String?
}
