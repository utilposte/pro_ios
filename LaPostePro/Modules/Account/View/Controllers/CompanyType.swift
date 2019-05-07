//
//  CompanyType.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 06/07/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import Foundation
import RealmSwift

class CompanyType: Object, Codable {
    @objc dynamic var code: String?
    @objc dynamic var name: String?
    
    func parseCompanyType(companyTypesFromResponse: [Any]) {
        let realm = try! Realm()
        deleteDatabaseObjectsBeforeAddingNewEllements(in: realm)
        realm.beginWrite()
        for companyType in companyTypesFromResponse {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: companyType, options: .prettyPrinted)
                let reqJSONStr = String(data: jsonData, encoding: .utf8)
                let data = reqJSONStr?.data(using: .utf8)
                let jsonDecoder = JSONDecoder()
                let aCompanyType = try jsonDecoder.decode(CompanyType.self, from: data!)
                self.persisteCompanyType(companyType: aCompanyType, database: realm)
            }
            catch {
                Logger.shared.debug("error creating CompanyType \(error)")
            }
        }
        try! realm.commitWrite()
    }
    private func persisteCompanyType(companyType: CompanyType, database: Realm) {
         database.create(CompanyType.self, value: companyType)
    }
    
    func getCompanyTypes() -> [CompanyType] {
        let realm = try! Realm()
        return Array(realm.objects(CompanyType.self))
    }
    
    private func deleteDatabaseObjectsBeforeAddingNewEllements(in realm: Realm) {
        try! realm.write {
            let allCompanyTypes = realm.objects(CompanyType.self)
            realm.delete(allCompanyTypes)
        }
    }
}
