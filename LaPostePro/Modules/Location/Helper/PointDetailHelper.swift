//
//  PointDetailHelper.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 01/08/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import Foundation

class PointDetailHelper: NSObject {
    func getPointPin(type: SelectedType) -> UIImage? {
        switch type {
        case .postOffice:
            return R.image.ic_pin_bp()
        case .depot:
            return R.image.ic_pin_bp()
        default:
            return R.image.ic_pin_bp()
        }
    }
}
