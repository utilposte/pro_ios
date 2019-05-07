//
//  Module.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 11/05/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import Foundation
import UIKit

enum InAppNavigationType {
    case redirectionToCategory
    case redirectionToBoutique
    case redirectionToStikers
    case redirectionToPackaging

}

enum ContentType {
    case cartList
    case cartReex
    case lastBuyList
    case favoritesList
    case bestSellCarousel
    case lastSeeCarousel
    case youWillLoveToo
    case otherCustomBuy
    case couldBeInterested
}

struct Module: Equatable {
    var moduleName: String?
    var moduleImage: UIImage?
    var moduleImageBackgroundColor: UIColor?
    var deepLink: String?
    var actionDescription: String?
    var items: [Product]?
    var moduleRedirectionType: InAppNavigationType?
    var contentType: ContentType?
    
    static func ==(lhs: Module, rhs: Module) -> Bool {
        return lhs.moduleName == rhs.moduleName && lhs.moduleImage == rhs.moduleImage
            && lhs.moduleImageBackgroundColor == rhs.moduleImageBackgroundColor
            && lhs.deepLink == rhs.deepLink && lhs.actionDescription == rhs.actionDescription
            && lhs.moduleRedirectionType == rhs.moduleRedirectionType
            && lhs.items == rhs.items
            && lhs.contentType == rhs.contentType
    }
}

extension Module {
    init(moduleName: String, moduleImage: UIImage, deepLink: String, with moduleImageBackgroundColor: UIColor, moduleRedirectionType: InAppNavigationType) {
        self.moduleName = moduleName
        self.moduleImage = moduleImage
        self.deepLink = deepLink
        self.moduleImageBackgroundColor = moduleImageBackgroundColor
        self.moduleRedirectionType = moduleRedirectionType
    }

    init(moduleName: String, moduleImage: UIImage, deepLink: String, actionDescription: String) {
        self.moduleName = moduleName
        self.moduleImage = moduleImage
        self.deepLink = deepLink
        self.actionDescription = actionDescription
    }

    init(moduleName: String, deepLink: String, actionDescription: String, items: [Product], contentType: ContentType) {
        self.moduleName = moduleName
        self.deepLink = deepLink
        self.actionDescription = actionDescription
        self.items = items
        self.contentType = contentType
    }

    init(contentType: ContentType, items: [Product]) {
        self.items = items
        self.contentType = contentType
    }

}
