//
//  LocationDetailCellDelegate.swift
//  LaPostePro
//
//  Created by Issam DAHECH on 10/08/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import Foundation
import MapKit

protocol LocationDetailCellDelegate {
    func showItinirary(postalOfficeCoordinate : CLLocationCoordinate2D, addressDict : [String : Any], routeString : String)
    func hideDetails()
    func showHours(hours : [Any])
    func showRetieveDeposteHours(hours : [Any])
}
