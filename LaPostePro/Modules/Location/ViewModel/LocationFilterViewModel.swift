//
//  LocationFilterViewModel.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 06/08/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import Foundation


class LocationFilterViewModel {
    
    var pointTypeSelectedValue = 0
    var hourSelectedValue = 0
    var daySeletedValue = 0
    
    func getFilterTitle(type: FilterType) -> String {
        switch type {
        case .day:
            return "Jour d’ouverture"
        default:
            return "Type  de point"
        }
    }
    
    func getFilterItemText(type: FilterType, index: Int) -> String {
        switch type {
        case .pointType:
            return Constants.pointTypeList[index]
        case .day:
            return Constants.daysList[index]
        case .pointTypeBp:
            return Constants.pointTypeListForBp[index]
        }
    }
    
    func getNumberOfItems(type: FilterType) -> CGFloat {
        switch type {
        case .day:
            return 4
        default:
            return 2
        }
    }
    
    func getDayFilterValue(index: Int) -> String {
        switch index {
        case 0:
            return ""
        default:
            return String(index)
        }
    }
    
    func getHourFilterValue(index: Int) -> String {
        switch index {
        case 0:
            return ""
        default:
            return String(index - 1)
        }
    }
    
    func getPointTypeFilterValue(type: FilterType, index: Int) -> String {
        switch type {
        case .pointType:
            if (index == 1) {
                return "office"
            } else if (index == 2){
                return "commercant"
            } else {
                return ""
            }
            //TODOs: Complete method when receiving key
//        case .pointTypeBp:
//
        default:
            return ""
        }
    }
    
    func hideResetButton() -> Bool {
        if hourSelectedValue == 0 && daySeletedValue == 0 && pointTypeSelectedValue == 0 {
            return true
        } else {
            return false
        }
    }
}
