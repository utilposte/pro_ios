//
//  CheckChorusResponse.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 03/10/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import Foundation

class CheckChorusResponse: Codable {
    
    var isChorusPartner: Bool
    
    var serviceList: [Service]?
    
    var siretNumber: String
    
    enum CodingKeys: String, CodingKey {
        case isChorusPartner = "chorus"
        case serviceList = "services"
        case siretNumber = "siret"
    }
}
