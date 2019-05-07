//
//  ArrivalCountry.swift
//  FBSnapshotTestCase
//
//  Created by Khaled El Abed on 05/10/2018.
//

import UIKit

public class CLCountry: Decodable, Equatable {
    public var activeForColissimo : Bool!
    public var calculateurDelai : Bool!
    public var hauteurmax :Int!
    public var hauteurmin : Int!
    public var isocode: String!
    public var largeurmax: Int!
    public var largeurmin : Int!
    public var longueurmax: Int!
    public var longueurmin: Int!
    public var name: String!
    public var onlyForColissimo: Bool!
    public var poidsmax: Double!
    public var poidsmin: Double!
    public var retour: Int!
    public var signMandatory: Bool!
    public var specificTerritory: Bool!
    
    public var originCountry: CLCountry?
    
    public static func == (lhs: CLCountry, rhs: CLCountry) -> Bool {
        return lhs.activeForColissimo == rhs.activeForColissimo
        && lhs.calculateurDelai == rhs.calculateurDelai
        && lhs.hauteurmax == rhs.hauteurmax
        && lhs.hauteurmin == rhs.hauteurmin
        && lhs.isocode == rhs.isocode
        && lhs.largeurmax == rhs.largeurmax
        && lhs.largeurmin == rhs.largeurmin
        && lhs.longueurmax == rhs.longueurmax
        && lhs.longueurmin == rhs.longueurmin
        && lhs.name == rhs.name
        && lhs.onlyForColissimo == rhs.onlyForColissimo
        && lhs.poidsmax == rhs.poidsmax
        && lhs.poidsmin == rhs.poidsmin
        && lhs.retour == rhs.retour
        && lhs.signMandatory == rhs.signMandatory
        && lhs.specificTerritory == rhs.specificTerritory
        && lhs.originCountry == rhs.originCountry
    }
}

/*extension CLCountry{
 convenience init?(data: [String: Any]) {
 self.init()
 guard let name = data["name"] as? String,
 let onlyForColissimo = data["onlyForColissimo"] as? Bool,
 let hauteurmax = data["hauteurmax"] as? Int,
 let hauteurmin = data["hauteurmin"] as? Int,
 
 let largeurmax = data["largeurmax"] as? Int,
 let largeurmin = data["largeurmin"] as? Int,
 
 let poidsmax = data["poidsmax"] as? Double,
 let poidsmin = data["poidsmin"] as? Double else {
 return nil
 }
 self.name = name
 self.onlyForColissimo = onlyForColissimo
 
 self.hauteurmax = hauteurmax
 self.hauteurmin = hauteurmin
 
 self.largeurmax = largeurmax
 self.largeurmin = largeurmin
 
 self.poidsmax = poidsmax
 self.poidsmin = poidsmin
 }
 }*/
