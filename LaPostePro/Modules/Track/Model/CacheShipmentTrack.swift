//
//  CacheShipmentTrack.swift
//  LaPostePro
//
//  Created by Matthieu Lemonnier on 03/08/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import Foundation
import LPSharedSUIVI
import RealmSwift

class CacheShipmentTrack: Object {
    @objc dynamic var code: String?
    @objc dynamic var json: String?
    @objc dynamic var needUpdate: String?
    @objc dynamic var lastUpdate: Date?
    
    static func save(responseTrack: ResponseTrack) -> Bool {
        let realm = try! Realm()
        
        if let code = responseTrack.num {
            let predicate = NSPredicate(format: "code = %@", code)
            let track = realm.objects(CacheShipmentTrack.self).filter(predicate)
            var cacheShipmentTrack = CacheShipmentTrack()
            if !track.isEmpty {
                if let trackObject = track.first {
                    cacheShipmentTrack = trackObject
                }
            }
            do {
                let encodedData = try JSONEncoder().encode(responseTrack)
                try! realm.write {
                    cacheShipmentTrack.json = String(data: encodedData, encoding: .utf8)
                    cacheShipmentTrack.code = responseTrack.num
                    let stringDate = (responseTrack.shipment?.events?.event?.first?.date) ?? Date().format("yyyy-MM-dd'T'HH:mm:ssZ")
                    cacheShipmentTrack.lastUpdate = Date.from(string: stringDate, withFormat: "yyyy-MM-dd'T'HH:mm:ssZ")
                    realm.add(cacheShipmentTrack)
                }
                return true
            }
            catch {
                return false
            }
        }
        return false
    }
    
    static func getResponseTrack(code: String) -> ResponseTrack? {
        do {
            let realm = try! Realm()
            let predicate = NSPredicate(format: "code = %@", code)
            let track = realm.objects(CacheShipmentTrack.self).filter(predicate)
            
            if let objTrack = track.first {
                if let jsonData = objTrack.json?.data(using: .utf8) {
                    let responseTrack = try JSONDecoder().decode(ResponseTrack.self, from: jsonData)
                    return responseTrack
                }
            }
        }
        catch {
            return nil
        }
        return nil
    }
}
