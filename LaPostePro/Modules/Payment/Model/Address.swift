//
//  Address.swift
//  LaPostePro
//
//  Created by Matthieu Lemonnier on 18/07/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import Foundation

class Address {
    var title : String? // Civility
    var firstName : String?
    var lastName : String?
    
    var line1 : String?
    var line2 : String?
    
    var town : String?
    var postalCode : String?
    var shippingAddress : Bool = false
    
    var country : String?
    var countryIsoCode : String?
}
