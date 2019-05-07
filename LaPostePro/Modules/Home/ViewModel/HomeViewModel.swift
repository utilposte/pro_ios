//
//  HomeViewModel.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 05/06/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import Foundation
import LPSharedMCM
import Firebase
import Alamofire
import SwiftyJSON

// Track
import LPSharedSUIVI
import RealmSwift

/*struct GreetingResponse: Codable {
    var params: [KeyValue]
}

struct KeyValue: Codable {
    var key: String
    var value: String
}*/

class HomeViewModel: NSObject {

    lazy var list = [HYBProduct]()
    var categories = [Category]()

    var greetingTitle = ""
    var greetingSubtitle = ""
    var carouselHtmlContent = ""

    override init() {
    }

    func setupCategories(completion:@escaping([Module]) -> Void) {
        let ref = Database.database().reference(withPath: "categories")

        ref.observe(.childAdded, with: { (snapshot) -> Void in
            if let category = Category(snapshot: snapshot) {

                self.categories.append(category)
                self.categories.sort(by: {(obj1, obj2) -> Bool in
                    return obj1.rank < obj2.rank
                })
                completion(self.modulesFor(categories: self.categories))
            }
        })

        ref.observe(.childRemoved, with: { (snapshot) -> Void in
            var index = 0
            for category in self.categories {
                if category.key == snapshot.key {
                    break
                }
                index += 1
            }
            self.categories.remove(at: index)
            self.categories.sort(by: {(obj1, obj2) -> Bool in
                return obj1.rank < obj2.rank
            })
            completion(self.modulesFor(categories: self.categories))
        })
    }

    func modulesFor(categories: [Category]) -> [Module] {
        var modules = [Module]()
        for category in categories {
            var module: Module
            if let image = UIImage(named: category.image) {
                module = Module.init(moduleName: category.key, moduleImage: image, deepLink: "", with: .clear, moduleRedirectionType: InAppNavigationType.redirectionToCategory)
            } else {
                module = Module.init(moduleName: category.key, moduleImage: R.image.stickersSuivis()!, deepLink: "", with: .clear, moduleRedirectionType: InAppNavigationType.redirectionToCategory)
            }
            modules.append(module)
        }
        return modules
    }


    func getProductList(query: String, completion: (@escaping ([HYBProduct]) -> Void)) {
        (MCMProductManager.sharedManager() as! MCMProductManager).getProductsAndDetails(byQuery: query) { (productList, _, _, _, _, _) in
            if productList != nil {
                completion(productList as! [HYBProduct])
            } else {
                completion(self.list)
            }
        }
    }

    func loadProductImageView(url: String, completion:@escaping (UIImage) -> Void) {

        (HYBB2CServiceWrapper.sharedInstance() as! HYBB2CServiceWrapper).backEndService.loadImage(byUrl: url) { (image, error) in
            if error == nil {
                completion(image!)
            } else {
                completion(R.image.beauxTimbres()!)
            }
        }
    }

    func getHomeCTAverticalListDetailText(productNumber: Int, specificText: String) -> NSMutableAttributedString {
        if productNumber == 0 {
            return NSMutableAttributedString()
        } else if productNumber == 1 {
            return NSMutableAttributedString()
                .custom(String(format: Constants.numberofHiddenProduct, productNumber), font: UIFont.systemFont(ofSize: 12, weight: .semibold), color: .lpDeepBlue)
                .custom(specificText, font: UIFont.systemFont(ofSize: 12), color: .lpGrey)
        } else {
            return NSMutableAttributedString()
            .custom(String(format: Constants.numberofHiddenProducts, productNumber), font: UIFont.systemFont(ofSize: 12, weight: .semibold), color: .lpDeepBlue)
            .custom(specificText, font: UIFont.systemFont(ofSize: 12), color: .lpGrey)
        }
    }

    func getPriceText(for contentType: ContentType, product: Product) -> NSMutableAttributedString {
        let priceType = ((product.priceType ?? "").elementsEqual("BUY")) ? "Prix Unitaire Net" : "Prix Unitaire HT"
        switch contentType {
        case .cartList:
            let price = product.isColissimo() ? product.optionColissimo?.totalNetPriceColis : product.price2
            return NSMutableAttributedString()
                .custom(String(format: "%@ ", price ?? ""), font: UIFont.boldSystemFont(ofSize: 15), color: .lpPurple)
        case .cartReex:
            let price = product.optionReex?.price
            return NSMutableAttributedString()
                .custom(String(format: "%@ ", price ?? ""), font: UIFont.boldSystemFont(ofSize: 15), color: .lpPurple)
        case .lastBuyList:
            return NSMutableAttributedString()
                .custom(String(format: "%@ ", product.price2 ?? ""), font: UIFont.init(size: 15), color: .lpPurple)
                .custom(priceType, font: UIFont.systemFont(ofSize: 13), color: .lpGrey)
        case .favoritesList:
            return NSMutableAttributedString()
                .custom(String(format: "%@ ", product.netPrice?.formattedValue ?? ""), font: UIFont.init(size: 15), color: .lpPurple)
                .custom(priceType, font: UIFont.systemFont(ofSize: 13), color: .lpGrey)
        default:
            return NSMutableAttributedString()
                .custom(String(format: "%@\n", product.price2 ?? ""), font: UIFont.init(size: 15), color: .lpPurple)
                .custom(priceType, font: UIFont.systemFont(ofSize: 13), color: .lpGrey)
        }
    }

    func getProductCountFromCart(for contentType: ContentType, product: Product) -> String {
        switch contentType {
        case .cartList:
            if let quantityInCart = product.quantityInCart {
                return "x\(quantityInCart)"
            } else {
                return ""
            }
        default:
            return ""
        }
    }

    func getCartRemainingProductsQuantity(for products: [Product]) -> Int {
        var remainingProducts = 0
        for i in 3...products.count - 1 {
            let product = products[i]
            remainingProducts += product.quantityInCart as! Int
        }
        return remainingProducts
    }

    func getVerticalListIcon(for contentType: ContentType) -> UIImage {
        switch contentType {
        case .cartList:
            return R.image.cart()!
        case .favoritesList:
            return R.image.favorites()!
        case .lastBuyList:
            return R.image.lastOrders()!
        default:
            return UIImage()
        }
    }

    // Get pro carrousel pages
    func getCarrouselContent(onCompletion: @escaping () -> Void) {
        HomeNetworkManager().getCarrouselContent {(isSucceeded, htmlContent) in
            if isSucceeded {
                self.carouselHtmlContent = htmlContent!
                onCompletion()
            }
        }
    }

    // Get welcoming messages
    func getWelcomingMessages(launchedBefore: Bool, onCompletion: @escaping () -> Void) {
        if !launchedBefore {
            self.greetingTitle = "Bonjour"
            self.greetingSubtitle = "Que faisons-nous aujourd'hui ?"
        } else {
            self.greetingTitle = "Bonjour"
            self.greetingSubtitle = "Ravi de vous revoir! Que faisons-nous aujourd'hui?"
        }
    }

    // Get TrackList
    func getTrackList() -> ([ResponseTrack], Bool)  {
        let realm = try! Realm()
        var shipmentCachedList = [ResponseTrack]()
        let shipments = realm.objects(CacheShipmentTrack.self)
        let showMore = shipments.count > 2
        let resultRealm = shipments.reversed().prefix(3)
        for shipment in resultRealm {
            if let code = shipment.code ,let currentTrack = CacheShipmentTrack.getResponseTrack(code: code) {
                shipmentCachedList.append(currentTrack)
            }
        }
        return (shipmentCachedList, showMore)

    }
}
