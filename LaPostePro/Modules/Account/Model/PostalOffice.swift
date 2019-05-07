//
//  PostalOffice.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 05/09/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import Foundation
import RealmSwift
import LPSharedLOC

class PostalOffice: Object {
    
    @objc dynamic var name: String?
    @objc dynamic var adresse: String?
    @objc dynamic var codePostal: String?
    @objc dynamic var codeSite: String?
    @objc dynamic var libelleSite: String?
    @objc dynamic var complementAdresse: String?
    @objc dynamic var lieuDit: String?
    @objc dynamic var localite: String?
    @objc dynamic var dateCalcul: String?
    @objc dynamic var dateChangement: String?
    @objc dynamic var heure: String?
    @objc dynamic var statut: String?
    @objc dynamic var type: String?
    @objc dynamic var libelleType: String?
    @objc dynamic var url: String?
    var services = List<String>()
    var accessibilite = List<String>()
    var horaires = List<String>()
    var horaireRetraitDepot = List<String>()
    @objc dynamic var latitude: Double = 0
    @objc dynamic var longitude: Double = 0
    
    internal func addPostalOffice(from: LOCPostalOffice, closure: ((Bool) -> ())?) {
        self.name = from.name
        self.adresse = from.adresse
        self.codePostal = from.codePostal
        self.codeSite = from.codeSite
        self.libelleSite = from.libelleSite
        self.complementAdresse = from.complementAdresse
        self.lieuDit = from.lieuDit
        self.localite = from.localite
        self.dateCalcul = from.statut.dateCalcul
        self.dateChangement = from.statut.dateChangement
        self.heure = from.statut.heure
        self.statut = from.statut.statut
        self.type = from.type
        self.libelleType = from.libelleType
        self.url = from.url
        
        if let _services = from.services as? [String] {
            for service in _services {
                self.services.append(service)
            }
        }
        
        if let _accessibilite = from.accessibilite as? [String] {
            for accessibilite in _accessibilite {
                self.accessibilite.append(accessibilite)
            }
        }

        if let _horaires = from.horaires as? [String] {
            for horaires in _horaires {
                self.horaires.append(horaires)
            }
        }

        if let _horaireRetraitDepot = from.horaireRetraitDepot as? [String] {
            for horaireRetraitDepot in _horaireRetraitDepot {
                self.horaireRetraitDepot.append(horaireRetraitDepot)
            }
        }
        
        self.latitude = from.latitude
        self.longitude = from.longitude
        
        do {
            let realm = try Realm()
            
            try realm.write {
                realm.add(self)
                closure!(true)
            }
        } catch _ as NSError {
            closure!(false)
        }
    }
    
    internal func deletePostalOffice(codeSite: String, completion: @escaping ((Bool) -> ())) {
        
        do {
            let realm = try Realm()
            
            if let postalOffice = realm.objects(PostalOffice.self).filter("codeSite == '\(codeSite)'").first {
                try realm.write {
                    realm.delete(postalOffice)
                    completion(true)
                }
            } else {
                completion(false)
            }
        } catch _ as NSError {
            completion(false)
        }
    }
}
