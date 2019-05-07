//
//  ProductFeature.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 14/06/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import Foundation
enum FeatureSize {
    case big
    case small
}

struct ProductFeature: Equatable {
    var name: String?
    var value: String?
    var featureSize: FeatureSize?
    
    static func ==(lhs: ProductFeature, rhs: ProductFeature) -> Bool {
        return lhs.name == rhs.name && lhs.value == rhs.value && lhs.featureSize == rhs.featureSize
    }
}
extension ProductFeature {
    init(name: String, value: String, size: FeatureSize) {
        self.name = name
        self.value = value
        self.featureSize = size
    }
}
