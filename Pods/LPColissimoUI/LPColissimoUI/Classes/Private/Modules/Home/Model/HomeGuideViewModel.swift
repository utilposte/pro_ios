//
//  HomeGuideViewModel.swift
//  LPColissimoUI
//
//  Created by Issam DAHECH on 22/10/2018.
//

import Foundation

struct HomeGuideViewModel {
    var idGuide     : Int
    var title       = ""
    var subTitle    = ""
    var isExpanded  = false
    var details     = [HomeGuideDetailViewModel]()
    init(idGuide : Int) {
        self.idGuide = idGuide
    }
    
    mutating func expand(){
        self.isExpanded = true
    }
}

struct HomeGuideDetailViewModel {
    var idGuide         : Int
    var title           = ""
    var text            = ""
    var isExpandable    = false
    var isExpanded      = false
    var images          = [String]()
    init(idGuide : Int) {
        self.idGuide = idGuide
    }
}

