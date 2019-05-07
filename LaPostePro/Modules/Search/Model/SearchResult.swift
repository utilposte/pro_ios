//
//  Search.swift
//  LaPostePro
//
//  Created by Issam DAHECH on 18/09/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

struct SearchResult {
    
    var title = ""
    var list = [UITableViewCell]()
    var showAllClosure : (() -> ())? = nil
}
