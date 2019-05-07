//
//  Address.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 09/10/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import Foundation

class AddressMascadia {
    var postalCode: String?
    var locality: String?
    var countryCode: String?
    var street: String?
    var lieuDit: String?
    var building: String?
    var apartment: String?
    var countryName: String?
    init(postalCode: String, locality: String, countryCode: String, street: String, lieuDit: String, building: String,apartment: String, countryName: String) {
        self.postalCode = postalCode
        self.locality = locality
        self.countryCode = countryCode
        self.street = street
        self.lieuDit = lieuDit
        self.building = building
        self.apartment = apartment
        self.countryName = countryName
    }
}
