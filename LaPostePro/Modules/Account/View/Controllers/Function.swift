//
//  Function.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 06/07/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import Foundation
import RealmSwift

class Function: Object, Codable {
    @objc dynamic var code: String?
    @objc dynamic var name: String?
    
    func parseFunctions(functionsFromResponse: [Any]) {
        let realm = try! Realm()
        realm.beginWrite()
        for function in functionsFromResponse {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: function, options: .prettyPrinted)
                let reqJSONStr = String(data: jsonData, encoding: .utf8)
                let data = reqJSONStr?.data(using: .utf8)
                let jsonDecoder = JSONDecoder()
                let aFunction = try jsonDecoder.decode(Function.self, from: data!)
                self.persisteFunction(function: aFunction, database: realm)
            }
            catch {
                Logger.shared.debug("error creating Function \(error)")
            }
        }
        try! realm.commitWrite()
    }
    private func persisteFunction(function: Function, database: Realm) {
        database.create(Function.self, value: function)
    }
    
    func getFunctions() -> [Function] {
        let realm = try! Realm()
        return Array(realm.objects(Function.self))
    }
}
