//
//  ColoredTabBarItem.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 22/05/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class ColoredTabBarItem: UITabBarItem {
    override func awakeFromNib() {
        if let image = image {
            self.image = image.withRenderingMode(.alwaysOriginal)
        }
        if let image = selectedImage {
            self.selectedImage = image.withRenderingMode(.alwaysOriginal)
        }
    }

}
