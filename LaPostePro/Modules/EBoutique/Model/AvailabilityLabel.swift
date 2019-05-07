//
//  AvailabilityLabel.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 29/05/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import Foundation
import UIKit

struct AvailabilityLabel {
    var text: String?
    var color: UIColor?
    var height: CGFloat?
}
extension AvailabilityLabel {
    init(text: String = "", color: UIColor = UIColor.clear, height: CGFloat = 16) {
        self.text = text
        self.height = height
        self.color = color
    }
}
