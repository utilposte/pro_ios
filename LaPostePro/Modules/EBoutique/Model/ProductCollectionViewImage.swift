//
//  ProductCollectionViewImage.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 14/06/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import Foundation
import UIKit

struct ProductCollectionViewImage {
    var image: UIImage?
    var index: Int?
    var highlited = false
}

extension ProductCollectionViewImage {
    init(image: UIImage, index: Int) {
        self.index = index
        self.image = image
    }
    
    init(image: UIImage) {
        self.image = image
    }
}
