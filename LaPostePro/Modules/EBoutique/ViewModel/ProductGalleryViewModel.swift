//
//  ProductGalleryViewModel.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 13/06/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import Foundation
import LPSharedMCM

class ProductGalleryViewModel: NSObject {
    var product: HYBProduct?
    func setOverLayForAllCell(productCollectionViewImages: [ProductCollectionViewImage]) -> [ProductCollectionViewImage] {
        var tmpArray = [ProductCollectionViewImage]()
        for productCollectionViewimage in productCollectionViewImages {
            var tmpProductImage = productCollectionViewimage
            tmpProductImage.highlited = false
            tmpArray.append(tmpProductImage)
        }
        return tmpArray
    }
}
