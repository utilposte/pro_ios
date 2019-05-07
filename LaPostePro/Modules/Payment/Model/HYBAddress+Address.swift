//
//  HYBAddress+Address.swift
//  LaPostePro
//
//  Created by Matthieu Lemonnier on 18/07/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import Foundation
import LPSharedMCM

extension HYBAddress {
    
    convenience init(address: Address) {
        self.init()
        self.title = address.title
        self.firstName = address.firstName
        self.lastName = address.lastName
        self.line1 = address.line1
        self.line2 = address.line2
        self.town = address.town
        
        self.postalCode = address.postalCode
        self.shippingAddress = address.shippingAddress
        
        self.country = LPSharedMCM.HYBCountry()
        self.country.isocode = address.countryIsoCode
        self.country.name = address.country
    }
    
    func getAddress() -> Address {
        let address = Address()
        address.title = title
        address.firstName = firstName
        address.lastName = lastName
        address.line1 = line1
        address.line2 = line2
        address.town = town
        address.postalCode = postalCode
        address.shippingAddress = shippingAddress
        address.country = self.country.name
        address.countryIsoCode = self.country.isocode
        return address
    }
}
