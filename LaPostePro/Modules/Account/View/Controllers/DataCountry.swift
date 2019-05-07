//
//  DataCountry.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 06/07/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import Foundation
import RealmSwift

class DataCountry: Object, Codable {
    @objc dynamic var isocode: String?
    @objc dynamic var name: String?
    
    func parseCountries(countryListFromResponse: [Any]) {
        let realm = try! Realm()
        deleteDatabaseObjectsBeforeAddingNewEllements(in: realm)
        realm.beginWrite()
        for country in countryListFromResponse {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: country, options: .prettyPrinted)
                let reqJSONStr = String(data: jsonData, encoding: .utf8)
                let data = reqJSONStr?.data(using: .utf8)
                let jsonDecoder = JSONDecoder()
                let aCountry = try jsonDecoder.decode(DataCountry.self, from: data!)
                self.persisteCountry(country: aCountry, realm: realm)
            }
            catch {
                Logger.shared.debug("error creating Country \(error)")
            }
        }
        try! realm.commitWrite()
    }
    private func persisteCountry(country: DataCountry, realm: Realm) {
        realm.create(DataCountry.self, value: country)
    }
    private func deleteDatabaseObjectsBeforeAddingNewEllements(in realm: Realm) {
        try! realm.write {
            let allCountries = realm.objects(DataCountry.self)
            realm.delete(allCountries)
        }
    }
    
    func getCounties() -> [DataCountry] {
        let realm = try! Realm()
        return Array(realm.objects(DataCountry.self))
    }
}
