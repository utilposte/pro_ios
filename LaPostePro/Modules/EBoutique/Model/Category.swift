//
//  Category.swift
//  LaPostePro
//
//  Created by Lassad Tiss on 25/05/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import Foundation
import Firebase

struct Category {

    let ref: DatabaseReference?
    let key: String
    let id: Int
    let rank: Int
    let image: String
    let subCategories: [Category]

    init(id: Int, rank: Int, key: String, image: String) {
        self.ref = nil
        self.key = key
        self.id = id
        self.rank = rank
        self.image = image
        self.subCategories = []
    }

    init?(snapshot: DataSnapshot) {
        self.ref = snapshot.ref
        self.key = snapshot.key
        let value = snapshot.value as! [String: Any]
        self.id = value["id"] as! Int
        self.rank = value["rank"] as! Int
        if let image = value["image"] as? String {
            self.image = image
        } else {
            self.image = ""
        }

        var subCategories = [Category]()

        if let categoryDictionary = value["subCategories"] as? [String: Any] {
            let subCategoryKeys = Array(categoryDictionary.keys)
            for key in subCategoryKeys {
                let subCategorDictionary = categoryDictionary[key] as! [String: Int]
                let id = subCategorDictionary["id"]!
                let rank = subCategorDictionary["rank"]!
                let subCategory = Category(id: id, rank: rank, key: key, image: "")
                subCategories.append(subCategory)
            }
        }

        self.subCategories = subCategories
        self.subCategories.sort {$0.rank < $1.rank}
    }

    func toAnyObject() -> Any {
        return [
            "key": key,
            "id": id,
            "rank": rank,
            "image": image,
            "subCategories": subCategories
        ]
    }
}
