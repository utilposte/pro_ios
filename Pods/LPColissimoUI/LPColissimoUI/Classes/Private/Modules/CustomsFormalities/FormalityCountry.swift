//
//  FormalityCountry.swift
//  LPColissimoUI
//
//  Created by Yonael Tordjman on 17/12/2018.
//

import UIKit

struct FormCountry: Codable {
    var departure_country_id: String
    var departure_country_name: String
    var arrival_country_id: String
    var arrival_country_name: String
    var has_customs_formalities: Int
}

class FormalityCountry {
    
    static let shared = FormalityCountry()
    var countries: [FormCountry] = []
    
    init() {
        let decoder = JSONDecoder()
        
        let bundle = Bundle(for: ColissimoManager.classForCoder())
        
        if let bundleURL = bundle.url(forResource: "LPColissimoUI", withExtension: "bundle") {
            if let bundle = Bundle(url: bundleURL) {
                if let path = bundle.path(forResource: "customs_formalities", ofType: "json") {
                    do {
                        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                        let decoded = try decoder.decode([FormCountry].self, from: data)
                        self.countries = decoded
                    } catch let error {
                        print(" === \(error.localizedDescription) === ")
                        print("An error occured while retrieving the JSON")
                        self.countries = []
                    }
                } else {
                    print("An error occured while retrieving the JSON")
                    self.countries = []
                }
            } else {
                print("An error occured while retrieving the JSON")
                self.countries = []
            }
        } else {
            print("An error occured while retrieving the JSON")
            self.countries = []
        }
    }
    
}
