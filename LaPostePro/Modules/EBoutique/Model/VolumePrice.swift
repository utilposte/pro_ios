//
//  VolumePrice.swift
//  LaPostePro
//
//  Created by Issam DAHECH on 14/12/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

struct VolumePrice {
    let range: String
    let price: String
    
    init(min : Int , max : Int?, price : String) {
        self.price = price
        if min == 1 {
            range = "À l'unité"
        }
        else if let _max = max {
            range = "De \(min) à \(_max)"
        }
        else {
            range = "À partir de \(min)"
        }
    }
}
