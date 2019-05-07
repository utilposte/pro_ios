//
//  ProductFavorite.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 08/10/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit
import RealmSwift

class ProductFavorite: Object {

    @objc dynamic var productCode: String?
    
    func save(productCode: String, completion: ((Bool) -> Void)?) {
        do {
            let realm = try Realm()

            try realm.write {
                
                self.productCode = productCode

                realm.add(self)
                completion!(true)
            }
        } catch _ as NSError {
            completion!(false)
        }
    }
    
    func delete(productCode: String, completion: ((Bool) -> Void)?) {
        do {
            let realm = try Realm()
            
            if let productFavorite = realm.objects(ProductFavorite.self).filter("productCode == '\(productCode)'").first {
                try realm.write {
                    realm.delete(productFavorite)
                    completion!(true)
                }
            } else {
                completion!(false)
            }
        } catch _ as NSError {
            completion!(false)
        }
    }
    
    func deleteAll() {
        do {
            let realm = try Realm()
            
            let productFavorite = realm.objects(ProductFavorite.self)
            try realm.write {
                realm.delete(productFavorite)
            }
        } catch _ as NSError {
        }
    }
    
    func fetchAll() -> Int {
        do {
            let realm = try Realm()
            
            let productFavorite = realm.objects(ProductFavorite.self)
            return productFavorite.count
        } catch _ as NSError {
            return 0
        }
    }
}
