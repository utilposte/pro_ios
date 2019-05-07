//
//  GeolocationManager.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 24/09/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import Foundation
import CoreLocation

class GeolocationManager {
    
    func geocode(latitude: Double, longitude: Double, completion: @escaping (CLPlacemark?, Error?) -> ())  {
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { completion($0?.first, $1) }
    }
}
