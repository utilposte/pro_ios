//
//  ColissimoObjectMapper.swift
//  LPColissimo
//
//  Created by Issam DAHECH on 25/10/2018.
//

import UIKit

public class ColissimoObjectMapper: NSObject {
    public class func getCountryFromIsoCode(_ countries: [CLCountry], isoCode : String) -> CLCountry?{
        let country = countries.filter{ $0.isocode == isoCode}
        return country.first
    }
    
    public class func priceString(price : Double) -> String {
        let formattedPrice = Double(round(100*price)/100)
        var resultPrice = String(format:"%.02f", formattedPrice)
        resultPrice = "\(resultPrice) €"
        resultPrice = resultPrice.replacingOccurrences(of: ".", with: ",")
        return resultPrice
    }
    
    public class func weightInKilos(weight : Double) -> String {
        var resultPrice = "\(weight) Kg"
        resultPrice = resultPrice.replacingOccurrences(of: ".", with: ",")
        return resultPrice
    }
    
    public class func weightInGrames(weight : Double) -> String {
        let weightInGrames = Int(weight*1000)
        var resultPrice = "(soit \(weightInGrames) g)"
        resultPrice = resultPrice.replacingOccurrences(of: ".", with: ",")
        return resultPrice
    }
}
