//
//  ProductDetailViewModel.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 12/06/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import Foundation
import LPSharedMCM
import Alamofire

class ProductDetailViewModel: NSObject {
    var categoryId: String?
    var product: HYBProduct?
    var boutiqueProduct: Product?
    lazy var list = [HYBProduct]()
    func createImageArrayForSlider(completion: @escaping([UIImage]) -> Void) {
        (HYBB2CServiceWrapper.sharedInstance() as! HYBB2CServiceWrapper).backEndService.loadImages(for: product) { (imageList, error) in
            if error != nil {
                completion([UIImage]())
            } else {
                completion(imageList as! [UIImage])
            }
        }
    }

    func addToCart(with quantity: String, onCompletion: @escaping(Bool, HYBCart) -> Void) {
        CartViewModel.sharedInstance.addProductToCart(product: Product(hybProduct: self.product!), quantityToAdd: Int(quantity)!) { (addedSuccessfully, cart) in
            onCompletion(addedSuccessfully, cart!)
        }
    }

    func createSmallListFeatures() -> [ProductFeature] {
        var smallFeaturesList = [ProductFeature]()
        if product?.delaiEnvoi.label != nil {
            let sendMode = ProductFeature.init(name: "Nature de l’envoi", value: (product?.delaiEnvoi.label)!, size: FeatureSize.small)
            smallFeaturesList.append(sendMode)
        }
        if product?.getWeight() != nil {
            let maxWeight = ProductFeature.init(name: "Poids maximum", value: (product?.getWeight())!, size: FeatureSize.small)
            smallFeaturesList.append(maxWeight)
        }
        if product?.destinationEnvoi.label != nil {
            let destination = ProductFeature.init(name: "Destination de l’envoi", value: (product?.destinationEnvoi.label)!, size: FeatureSize.small)
            smallFeaturesList.append(destination)
        }
        return smallFeaturesList
    }

    func createBigListFeatures() -> [ProductFeature] {
        var bigFeaturesList = createSmallListFeatures()

        let permanantValidity = ProductFeature.init(name: "Validité permanente", value: (product?.getPermanentValidity())!.contains("yes") ? "Oui" : "Non", size: FeatureSize.small)
        bigFeaturesList.append(permanantValidity)
        let productPresentation = ProductFeature.init(name: "Présentation du produit", value: (product?.getPresentationFormat())!, size: FeatureSize.small)
        bigFeaturesList.append(productPresentation)
        //let tracking = ProductFeature.init(name: "Numéro de suivi", value: product.numer, size: )
//        if (product?.typeProduit != nil) {
//            let type = ProductFeature.init(name: "Type d’enveloppe", value: (product?.typeProduit.label)!, size: FeatureSize.small)
//            bigFeaturesList.append(type)
//        }
        if let nbTimbreString = product?.nbTimbreParPresentation {
            let nbTimbre = ProductFeature.init(name: "Nombre de timbres", value: "\(nbTimbreString)", featureSize: .small)
            bigFeaturesList.append(nbTimbre)
        }                
        
        if let thematique = product?.thematiques as? [HYBThematiques] {
            let nbTimbre = ProductFeature.init(name: "Thématique", value: "\(thematique.last?.label ?? "")", featureSize: .small)
            bigFeaturesList.append(nbTimbre)
        }
        
        let validityZone = ProductFeature.init(name: "Zone de validité", value: (product?.getValidityArea())!, size: FeatureSize.big)
        bigFeaturesList.append(validityZone)
        let dimenssions = ProductFeature.init(name: "Dimensions", value: (product?.formatAvecDents)!, size: FeatureSize.small)
        bigFeaturesList.append(dimenssions)
        let emissionDate = ProductFeature.init(name: "Date d’émission", value: (product?.getEmissionDate())!, size: FeatureSize.small)
        bigFeaturesList.append(emissionDate)
        return bigFeaturesList
    }

    func getNewFeaturesListSize(featuresList: [ProductFeature]) -> FeatureSize {
        if featuresList.count == 3 {
            return .big
        } else {
            return .small
        }
    }
    func getActuelFeaturesListSize(featuresList: [ProductFeature]) -> FeatureSize {
        if featuresList.count == 3 {
            return .small
        } else {
            return .big
        }
    }

    func getLongDescription() -> ProductFeature {
        return ProductFeature.init(name: "Description détaillée", value: (product?.descriptor)!, size: FeatureSize.big)
    }

    func getPriceFormattedAttributtedText() -> NSAttributedString {
        let priceType = "Prix Unitaire \(product!.getTextTax()!) "

         return NSMutableAttributedString()
            .custom(String(format: "%@ ", (product?.netPrice.formattedValue)!), font: UIFont.init(size: 24), color: .lpPurple)
            .custom(priceType, font: UIFont.systemFont(ofSize: 13), color: .lpGrey)
    }

    func getAvailibilityLabel(stockStatus: StockStatus) -> AvailabilityLabel {
        switch stockStatus {
        case .inStock:
            return AvailabilityLabel.init(text: "", color: .clear, height: 0)
        case .lowStock:
            return AvailabilityLabel.init(text: Constants.lowStockProductText, color: UIColor.lpRedForUnavailableProduct, height: 32)
        case .outOfStock:
            return AvailabilityLabel.init(text: Constants.notAvailableProductText, color: UIColor.lpRedForUnavailableProduct, height: 32)
        }
    }

    func getUnavailabilityAlertText(stockStatus: StockStatus) -> String {
        switch stockStatus {
        case .outOfStock:
            return R.string.localizable.outofstock_alert_text()
        default:
            return ""
        }
    }

    func getCellButtonText(stockStatus: StockStatus) -> String {
        switch stockStatus {
        case .outOfStock:
            return R.string.localizable.outofstock_button_text()
        default:
            return R.string.localizable.instock_button_text()
        }
    }
    
    func getVolumePriceList() -> [VolumePrice]? {
        if let list = product?.volumePrices as? [HYBPrice] {
            var resultList = [VolumePrice]()
            for price in list {
                let volumePrice = VolumePrice(min: Int(truncating: price.minQuantity ?? 0), max: price.maxQuantity as? Int, price: price.formattedValue ?? "0,0 €")
                resultList.append(volumePrice)
            }
            if resultList.count == 0 {
                return nil
            }
            return resultList
        }
        
        return nil
    }

    func getCellButtonBackgroundColor(stockStatus: StockStatus) -> UIColor {
        switch stockStatus {
        case .outOfStock:
            return .lpDeepBlue
        default:
            return .lpPurple
        }
    }

    func getCellButtonIcon(stockStatus: StockStatus) -> UIImage? {
        switch stockStatus {
        case .outOfStock:
            return R.image.alert()
        default:
            return nil
        }
    }

    func getStockStatus() -> StockStatus {
        switch product?.stock.stockLevelStatus {
        case "inStock":
            return .inStock
        case "lowStock":
            return .lowStock
        case "outOfStock":
            return .outOfStock
        default:
            return .inStock
        }
    }


    func getProductName() -> String {
        return product?.name ?? ""
    }
    func getProductList(query: String, completion: (@escaping ([HYBProduct]) -> Void)) {
        (HYBB2CServiceWrapper.sharedInstance() as! HYBB2CServiceWrapper).backEndService.resetPagination()
        (MCMProductManager.sharedManager() as! MCMProductManager).getProductsAndDetails(byQuery: query) { (productList, _, _, _, _, _) in
            if productList != nil {
                completion(productList as! [HYBProduct])
            } else {
                completion(self.list)
            }
        }
    }
}

extension ProductDetailViewModel {
    func setProductWishlist(product: String, completion: ((Bool) -> ())?) {
        // CREATE HTTP HEADER
        let keychainService = KeychainService()
        let authorization = String(format: "Bearer %@", keychainService.get(key: keychainService.accessTokenkey) ?? "")
        
        let headers :[String: String?] = [
            "Authorization": authorization,
            "Content-Type": "application/json"
        ]
        
        let urlString = "https://" + EnvironmentUrlsManager.sharedManager.getHybrisServiceHost() + "/eboutiquecommercewebservices/v2/eboutiquePro/users/"
        guard let email = UserAccount.shared.customerInfo?.displayUid else { Logger.shared.debug("Error"); return }
        let urlString2 = urlString + email + Constants.wishlist + "?productCode=\(product)"
        
        let url = URL(string: urlString2)
        guard let _url = url else {
            return
        }
        
        var request = URLRequest(url: _url)
        request.httpMethod = HTTPMethod.put.rawValue
        request.allHTTPHeaderFields = headers as? [String : String]
        
        Alamofire.request(request)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success( _):
                    completion!(true)
                case .failure:
                    Logger.shared.debug("Fail")
                    if (response.response?.statusCode)! >= 200 && (response.response?.statusCode)! <= 299 {
                        completion!(true)
                    } else {
                        completion!(false)
                    }
                }
        }
    }
    
    func notifyMeWhenAvailable(oncompletion: @escaping () -> Void) {
        //products/[product]/alerts/stock?lastName=[lastName]&firstName=[firstName]&email=[email]
        guard let firstName = UserAccount.shared.customerInfo?.firstName, let lastName = UserAccount.shared.customerInfo?.lastName, let email = UserAccount.shared.customerInfo?.displayUid, let productId = product?.code else {
            return
        }
        let params = ["firstName": firstName,
                      "lastName": lastName,
                      "email": email]
        (HYBB2CServiceWrapper.sharedInstance() as! HYBB2CServiceWrapper).backEndService.setAlertAvailabilityForUser(params as [AnyHashable : Any], productCode: productId) {
            oncompletion()
        }
    }
}
