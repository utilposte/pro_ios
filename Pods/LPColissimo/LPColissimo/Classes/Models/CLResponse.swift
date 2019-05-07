//
//  ColissimoResponse.swift
//  LPColissimo
//
//  Created by Khaled El Abed on 05/10/2018.
//

import Foundation

///// Top level response for every request to the Marvel API
///// Everything in the API seems to be optional, so we cannot rely on having values here
//public struct CLResponse<Response: Decodable>: Decodable {
//    /// Whether it was ok or not
//    public let status: String?
//    /// Message that usually gives more information about some error
//    public let message: String?
//    /// Requested data
//    public let data: DataContainer<Response>?
//}


/// All successful responses return this, and contains all
/// the metainformation about the returned chunk.
public struct DataContainer: Decodable {
    //    public let offset: Int
    //    public let limit: Int
    //    public let total: Int
    //    public let count: Int
    //    public let results: Results
    
    public let arrivalCountries : [CLCountry]
    public let departuresCountries: [CLCountry]
    
    public let colisFormats : [CLFormat]
    public let contentsNatures: [CLContentsNature]
    
    public let defaultArrivalCountry: String
    public let defaultDepartureCountry: String
    
    public let defaultCompensationByWeight: Double
    public let defaultPrice:CLPrice
    
    
    public let internationalInsurances: [CLInsurance]
    public let nationalInsurances: [CLInsurance]
}


/// Dumb error to model simple errors
/// In a real implementation this should be more exhaustive
public enum CLError: Error {
    case encoding
    case decoding
    case server(message: String)
}
