//
//  Encodable+Dictionary.swift
//  LaPostePro
//
//  Created by Issam DAHECH on 27/11/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import Foundation

extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
}
