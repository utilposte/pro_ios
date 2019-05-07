//
//  CarouselViewModel.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 07/06/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import Foundation
import UIKit

class CarouselViewModel: NSObject {
    func getTitleForCarouselItem(contentType: ContentType) -> String {
        switch contentType {
        case .lastSeeCarousel:
            return "Derniers produits vus"
        case .couldBeInterested:
            return "Ce qui pourrait vous intéresser"
        case .bestSellCarousel:
            return "Meilleures ventes"
        case .youWillLoveToo:
            return "Vous aimerez aussi"
        case .otherCustomBuy:
            return "Les autres clients ont acheté"
        default:
            return ""
        }
    }
}
