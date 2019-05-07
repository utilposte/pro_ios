//
//  PixelWeboramaManager.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 18/09/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import Foundation
import AdSupport

@objc enum WeboramaActionType: Int {
    case vis = 0
    case addToCart = 1
    case buy = 2
}

class PixelWeboramaManager: NSObject {
    
    //Rubrique Tags
    private let screen1RubriqueKey = "Ecran1"
    private let serviceRubriqueKey = "Service"
    private let productRubriqueKey = "Articles"
    
    //Article Tags
    private let accountArticleKey = "Mon_Compte"
    private let trackArticleKey = "Suivi"
    private let localiserArticleKey = "Localiser"
    private let addressArticleKey = "Adresse"
    private let contactArticleKey = "Contact"
    private let marianneTimbreArticleKey = "Timbres_Marianne"
    private let beautifulTimbreArticleKey = "Beaux_Timbres"
    private let envpaArticleKey = "Enveloppes_PreAffranchies"
    private let embapaArticleKey = "Emballages_PreAffranchies"
    private let stickerArticleKey = "Stickers_Suivi"
    
    //Action Tags
    private let addToCartActionKey = "MAP"
    private let buyActionKey = "ACHAT"
    
    
    @objc func sendWeboramaTag(tagToSend: String, ccuIDCryptedValue: String) {
        
        let advertizingId = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        let jsonToSend = getDataForTag(with: tagToSend, and: ccuIDCryptedValue)
        let random = Int(arc4random_uniform(1000))
        
        let stringUrl = String(format: Constants.weboramaUrl, Constants.weboramaBaseUrl, advertizingId, jsonToSend, random)
        guard let url = URL(string: stringUrl) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            if let error = responseError {
                Logger.shared.debug(error.localizedDescription)
            } else {
                Logger.shared.debug(responseData?.base64EncodedString() ?? "")
            }
        }
        task.resume()
    }
    
    private func getDataForTag(with tagToSend: String, and ccuIdSHA256Value: String) -> String {
        switch tagToSend {
        case Constants.allWeboramaKey:
            return self.createJsonData(rubrique: screen1RubriqueKey, product: "", action: "", ccuId: ccuIdSHA256Value)
            
        case Constants.accountWeboramaKey:
            return self.createJsonData(rubrique: serviceRubriqueKey, product: accountArticleKey, action: "", ccuId: ccuIdSHA256Value)

        case Constants.trackingWeboramaKey:
            return self.createJsonData(rubrique: serviceRubriqueKey, product: trackArticleKey, action: "", ccuId: ccuIdSHA256Value)

        case Constants.localiserWeboramaKey:
            return self.createJsonData(rubrique: serviceRubriqueKey, product: localiserArticleKey, action: "", ccuId: ccuIdSHA256Value)
            
        case Constants.checkAddressWeboramaKey:
            return self.createJsonData(rubrique: serviceRubriqueKey, product: addressArticleKey, action: "", ccuId: ccuIdSHA256Value)
            
        case Constants.contactUsWeboramaKey:
            return self.createJsonData(rubrique: serviceRubriqueKey, product: contactArticleKey, action: "", ccuId: ccuIdSHA256Value)
            
        case Constants.marianneVisWeboramaKey:
            return self.createJsonData(rubrique: productRubriqueKey, product: marianneTimbreArticleKey, action: "", ccuId: ccuIdSHA256Value)
            
        case Constants.marianneAddToCartWeboramaKey:
            return self.createJsonData(rubrique: productRubriqueKey, product: marianneTimbreArticleKey, action: addToCartActionKey, ccuId: ccuIdSHA256Value)
            
        case Constants.marianneBuyWeboramaKey:
            return self.createJsonData(rubrique: productRubriqueKey, product: marianneTimbreArticleKey, action: buyActionKey, ccuId: ccuIdSHA256Value)
            
        case Constants.beautifulTimbreVisWeboramaKey:
            return self.createJsonData(rubrique: productRubriqueKey, product: beautifulTimbreArticleKey, action: "", ccuId: ccuIdSHA256Value)
            
        case Constants.beautifulTimbreAddToCartWeboramaKey:
            return self.createJsonData(rubrique: productRubriqueKey, product: beautifulTimbreArticleKey, action: addToCartActionKey, ccuId: ccuIdSHA256Value)
            
        case Constants.beautifulTimbreBuyWeboramaKey:
            return self.createJsonData(rubrique: productRubriqueKey, product: beautifulTimbreArticleKey, action: buyActionKey, ccuId: ccuIdSHA256Value)
            
        case Constants.envpaVisWeboramaKey:
            return self.createJsonData(rubrique: productRubriqueKey, product: envpaArticleKey, action: "", ccuId: ccuIdSHA256Value)
            
        case Constants.envpaAddToCartWeboramaKey:
            return self.createJsonData(rubrique: productRubriqueKey, product: envpaArticleKey, action: addToCartActionKey, ccuId: ccuIdSHA256Value)
            
        case Constants.envpaBuyWeboramaKey:
            return self.createJsonData(rubrique: productRubriqueKey, product: envpaArticleKey, action: buyActionKey, ccuId: ccuIdSHA256Value)
            
        case Constants.embapaVisWeboramaKey:
            return self.createJsonData(rubrique: productRubriqueKey, product: embapaArticleKey, action: "", ccuId: ccuIdSHA256Value)
            
        case Constants.embapaAddToCartWeboramaKey:
            return self.createJsonData(rubrique: productRubriqueKey, product: embapaArticleKey, action: addToCartActionKey, ccuId: ccuIdSHA256Value)
            
        case Constants.embapaBuyWeboramaKey:
            return self.createJsonData(rubrique: productRubriqueKey, product: embapaArticleKey, action: buyActionKey, ccuId: ccuIdSHA256Value)
            
        case Constants.stickerVisWeboramaKey:
            return self.createJsonData(rubrique: productRubriqueKey, product: stickerArticleKey, action: "", ccuId: ccuIdSHA256Value)
            
        case Constants.stickerAddToCartWeboramaKey:
            return self.createJsonData(rubrique: productRubriqueKey, product: stickerArticleKey, action: addToCartActionKey, ccuId: ccuIdSHA256Value)
            
        case Constants.stickerBuyWeboramaKey:
            return self.createJsonData(rubrique: productRubriqueKey, product: stickerArticleKey, action: buyActionKey, ccuId: ccuIdSHA256Value)

        default:
            return self.createJsonData(rubrique: "", product: "", action: "", ccuId: "")
        }
    }
    
    private func createJsonData(rubrique: String, product: String, action: String, ccuId: String) -> String {
        var string = String(format: "{\"d\":\"app.cotepro\",\"userid\":\"%@\",\"SUBFOLDER_2\":\"%@\",\"SUBFOLDER_3\":\"%@\",\"SUBFOLDER_4\":\"%@\"}", ccuId.sha256() ?? "", rubrique, product, action).addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlHostAllowed) ?? ""
        string = string.replacingOccurrences(of: ",", with: "%2C")
        return string
    }
    
    @objc func getKey(from categoryId: String, and actiontype: WeboramaActionType) -> String {
        if (Constants.beautifulTimbreCategoryId.contains(categoryId)) {
            switch actiontype {
                case .vis: return Constants.beautifulTimbreVisWeboramaKey
                case .addToCart: return Constants.beautifulTimbreAddToCartWeboramaKey
                case .buy: return Constants.beautifulTimbreBuyWeboramaKey
            }
        } else if (Constants.marianneTimbreCategoryId.contains(categoryId)) {
            switch actiontype {
                case .vis: return Constants.marianneVisWeboramaKey
                case .addToCart: return Constants.marianneAddToCartWeboramaKey
                case .buy: return Constants.marianneBuyWeboramaKey
            }
        } else if (Constants.stickerCategoryId.contains(categoryId)) {
            switch actiontype {
                case .vis: return Constants.stickerVisWeboramaKey
                case .addToCart: return Constants.stickerAddToCartWeboramaKey
                case .buy: return Constants.stickerBuyWeboramaKey
            }
        }else if (Constants.envpaCategoryId.contains(categoryId)) {
            switch actiontype {
                case .vis: return Constants.envpaVisWeboramaKey
                case .addToCart: return Constants.envpaAddToCartWeboramaKey
                case .buy: return Constants.envpaBuyWeboramaKey
            }
        } else if (Constants.embpaCategoryId.contains(categoryId)) {
            switch actiontype {
                case .vis: return Constants.embapaVisWeboramaKey
                case .addToCart: return Constants.embapaAddToCartWeboramaKey
                case .buy: return Constants.embapaBuyWeboramaKey
            }
        } else {
            switch actiontype {
                case .vis: return ""
                case .addToCart: return ""
                case .buy: return ""
            }
        }
    }
    
    @objc func getCcuId() -> String {
        return UserAccount.shared.customerInfo?.displayUid ?? ""
    }
}
