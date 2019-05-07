//
//  LPAddressEntity.swift
//  laposte
//
//  Created by Sofien Azzouz on 05/02/2018.
//  Copyright © 2018 laposte. All rights reserved.
//
class CTCountry : NSObject {
    var libelle : String!
    var zoneGroup : [String]!
    public override init() {}
    
    public init(dic : [String : Any]) {
        
        if let libelle = dic["libelle"] as? String {
            self.libelle = libelle
        }
        
        if let zoneGroup = dic["zone"] as? [String] {
            self.zoneGroup = zoneGroup
        }
    }
}

/*class LPAddressEntity: NSObject{
    
    var civility = ""
    var companyName = ""
    var serviceName = ""
    //var serviceExpediteur : String?
    var firstName = ""
    var lastName = ""
    var email = ""
    var phone = ""
    var complementaryAddress = ""
    var street = ""
    var postalCode = ""
    var locality = ""
    var countryName = ""
    var countryIsoCode = ""
    var formattedAddress = ""
    
    var placeIDForGooglePlaces = ""

    var isLocal = ""
    
    func toString(){
        print("*********  LPAddressEntity | \(#function)" )
        print("********* \n\(civility)\n|name:\(companyName) \n|serviceName: \(serviceName) \n|firstName:\(firstName)|lastName:\(lastName)\n|email:\(email)\n|street:\(street)\n|postalCode:\(postalCode)\n|locality:\(locality)|countryName:\(countryName)\n|countryIsoCode:\(countryIsoCode)")
    }
}*/

