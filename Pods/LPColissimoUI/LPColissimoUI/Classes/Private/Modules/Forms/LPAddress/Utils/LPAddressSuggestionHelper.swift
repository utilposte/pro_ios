//
//  LPAddressSuggestionHelper.swift
//  laposte
//
//  Created by Sofien Azzouz on 28/02/2018.
//  Copyright © 2018 laposte. All rights reserved.
//


class LPAddressSuggestionHelper: NSObject{


    static func saveAddressSuggestionLocally(placesArray: [Dictionary<String, String>]) {
        var tenFirstElements: [Dictionary<String, String>]?
        if placesArray.count > 10 {
            tenFirstElements = Array(placesArray[0..<10]) // 0,1,2,3,4,5...9
        } else {
            tenFirstElements = placesArray
        }
        let placesData = NSKeyedArchiver.archivedData(withRootObject: tenFirstElements!)
        
        UserDefaults.standard.set(placesData, forKey: "addressSuggestionGP")
    }

    static func getSavedSuggestionAddress() -> [Dictionary<String, String>] {
        let placesData = UserDefaults.standard.object(forKey: "addressSuggestionGP") as? NSData
        
        if let placesData = placesData {
            let placesArray = NSKeyedUnarchiver.unarchiveObject(with: placesData as Data) as? [Dictionary<String, String>]
            //print(placesArray)
            return placesArray!
        
        }
        
        return [Dictionary<String, String>]()
    }
    
    static func deleteAddress(lpAddress: LPAddressEntity) {
        var placesData = getSavedSuggestionAddress()
        
        var  index : Int = 0
        for dic in placesData  {
            if dic["placeIDForGooglePlaces"] == lpAddress.placeIDForGooglePlaces {
                placesData.remove(at: index)
                saveAddressSuggestionLocally(placesArray: placesData)
                break
            }
            index = index+1;
        }
    }
    
    static func convertLPAddressToDictionary(lpAddress: LPAddressEntity) -> Dictionary<String, String> {
        let dic = [ "placeIDForGooglePlaces" : lpAddress.placeIDForGooglePlaces,
                    "street" : lpAddress.street,
                    "postalCode" : lpAddress.postalCode,
                    "locality" : lpAddress.locality,
                    "countryName" : lpAddress.countryName,
                    "isLocal" : "local"]
        return dic
    }
    
    static func convertDictionaryToLPAddress(dic: Dictionary<String, String>) -> LPAddressEntity {
        let lpAddress = LPAddressEntity()
        lpAddress.placeIDForGooglePlaces = dic["placeIDForGooglePlaces"] ?? ""
        lpAddress.street = dic["street"] ?? ""
        lpAddress.postalCode = dic["postalCode"] ?? ""
        lpAddress.locality = dic["locality"] ?? ""
        lpAddress.countryName = dic["countryName"] ?? ""
        lpAddress.isLocal = dic["isLocal"] ?? ""
        
        return lpAddress
    }

}
