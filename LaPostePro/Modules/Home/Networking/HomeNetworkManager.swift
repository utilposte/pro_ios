//
//  HomeNetworkManager.swift
//  LaPostePro
//
//  Created by Lassad Tiss on 12/07/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import Alamofire
import SwiftyJSON

struct GreetingResponse: Codable {
    var params: [KeyValue]
}

struct KeyValue: Codable {
    var key: String
    var value: String
}

class HomeNetworkManager: NSObject {

    // Get pro carrousel pages
    func getCarrouselContent(onCompletion: @escaping (Bool, String?) -> Void) {
        
        // Add Headers
        let headers = [
            "Accept":"application/json",
            ]
        
        // Request Url
        let requestlUrl = String(format: "https://%@/eboutiquecommercewebservices/v2/eboutiquePro/carrousel/proCarrouselPage", EnvironmentUrlsManager.sharedManager.getHybrisServiceHost())
        
        // Fetch Request
        Alamofire.request(requestlUrl, method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                if (response.result.error == nil) {
                    let json = JSON(response.value!)
                    if let htmlContent = json["content"].string {
                        onCompletion(true, htmlContent)
                    } else {
                        onCompletion(false, nil)
                    }
                }
                else {
                    onCompletion(false, nil)
                }
        }
    }
    
    // Get welcoming messages
    func getWelcomingMessages(isFirstTime: Bool, onCompletion: @escaping (Bool, String?, String?) -> Void) {
        
        var keys: String
        if isFirstTime {
            keys = "connexion.welcome.msg.title,connexion.welcome.msg.subtitle"
        }
        else {
            keys = "second.connexion.welcome.msg.title,second.connexion.welcome.msg.subtitle"
        }
        // Add URL parameters
        let urlParams = [
            "keys": keys,
            ]
        
        // Request Url
        let url = "https://" + EnvironmentUrlsManager.sharedManager.getHybrisServiceHost()
        let requestlUrl = url+"/eboutiquecommercewebservices/v2/eboutiquePro/configParams"
        
        // Fetch Request
        Alamofire.request(requestlUrl, method: .get, parameters: urlParams)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                if (response.result.error == nil) {
                    do {
                        var greetingTitle = ""
                        var greetingSubtitle = ""
                        let greetings = try JSONDecoder().decode(GreetingResponse.self, from: response.data!)
                        for greeting in greetings.params {
                            if greeting.key.contains(".title") {
                                greetingTitle = greeting.value
                            } else {
                                greetingSubtitle = greeting.value
                            }
                        }
                        onCompletion(true, greetingTitle, greetingSubtitle)
                    } catch {}
                }
                else {
                    onCompletion(false, nil, nil)
                }
        }
    }
    
}
