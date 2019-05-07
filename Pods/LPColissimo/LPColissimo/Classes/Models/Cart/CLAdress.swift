//
//  CLAdress.swift
//  LPColissimo
//
//  Created by SPASOV DIMITROV Vladimir on 25/10/18.
//

import Foundation

public struct CLAdress : Codable {
    
    public let companyName : String?
    public let country : CLCountryName?
    public let email : String?
    public let firstName : String?
    public let formattedAddress : String?
    public let lastName : String?
    public let line1 : String?
    public let line2 : String?
    public let phone : String?
    public let postalCode : String?
    public let region : String?
    public let shippingAddress : Bool?
    public let title : String?
    public let titleCode : String?
    public let town : String?
    public let visibleInAddressBook : Bool?
    
    public let appartment : String?
    public let building : String?
    public let pobox : String?
    public let pro : Bool?
    public let streetNumber : String?
}


public struct CLCountryName : Codable {
    
    public let isocode : String?
    public let name : String?
    
}
