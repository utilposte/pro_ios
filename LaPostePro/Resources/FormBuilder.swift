//
//  FormBuilder.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 10/07/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import Foundation
import UIKit

struct FormBuilder: Codable {
    var Pays: String?
    var TVA_intracommunautaire: String?
    var Type_societe_obligatoire: String?
    var SIRET_obligatoire: String?
    
    func getFormBuilderList() -> [FormBuilder] {
        var formBuilderList = [FormBuilder]()
        if let path = Bundle.main.path(forResource: "inscription_form_builder", ofType: "json")
        {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                formBuilderList = try JSONDecoder().decode([FormBuilder].self, from: data)
            } catch {
                //error
            }
        }
        return formBuilderList
    }
}
