//
//  FrandoleNetworkManager.swift
//  LaPostePro
//
//  Created by Lassad Tiss on 12/07/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import Alamofire
import SwiftyJSON

struct FrandolesResponse: Codable {
    var farandoles: [Frandole]
}

struct Frandole: Codable {
    var name: String
    var products: [Product]?
    
    enum CodingKeys: String, CodingKey {
        case name
        case products = "produits"
    }
}

class FrandoleNetworkManager: NSObject {
    
    func getFarandoles(onCompletion: @escaping (Bool, [Frandole]?) -> Void) {
        
        // Add Headers
        let keychainService = KeychainService()
        let authorization = String(format: "Bearer %@", keychainService.get(key: keychainService.accessTokenkey) ?? "")
        let headers = [
            "Authorization": authorization,
            "Accept": "application/json",
            ]
        
        // Add URL parameters
        let urlParams = [
            "options":"BEST_SELLERS,INTERESTING_PRODUCTS,COMMAND_PRODUCTS,YOUWOULDLIKE_PRODUCTS,MOST_PURCHASSED,MOST_PURCHASSED_BY_OTHERS",
            ]
        
        // Request Url
        let requestlUrl = String(format: "https://%@/eboutiquecommercewebservices/v2/eboutiquePro/users/%@/farandoles", EnvironmentUrlsManager.sharedManager.getHybrisServiceHost(), keychainService.get(key: keychainService.emailkey) ?? "")
        // Fetch Request
        Alamofire.request(requestlUrl, method: .get, parameters: urlParams, encoding: URLEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                if (response.result.error == nil) {
                    do {
                        let response = try JSONDecoder().decode(FrandolesResponse.self, from: response.data!)
                        onCompletion(true, response.farandoles)
                    } catch let error { Logger.shared.debug(error.localizedDescription) }
                }
                else {
                    onCompletion(false, nil)
                }
        }
    }

}
