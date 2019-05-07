//
//  SearchElement.swift
//  LaPostePro
//
//  Created by Issam DAHECH on 18/09/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit
import RealmSwift

class SearchElement: Object {
    @objc dynamic var text : String = ""
    @objc dynamic var type : Int = 1
}
