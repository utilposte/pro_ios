//
//  SharedLocNetworkManager.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 15/04/2019.
//  Copyright © 2019 App Mobile. All rights reserved.
//

import UIKit
import LPSharedLOC
import Alamofire

extension LOCSharedManager {
    
    func fetchProPostOffices(place: String, success: @escaping ((PostOfficesPro) -> Void), failure: @escaping (() -> Void)) {
        var urlString = ""
        
        if self.isPostalCode(place: place) {
            urlString = "https://www.laposte.fr/recherche/bureau/codepostal/\(place)"
        } else {
            urlString = "https://www.laposte.fr/recherche/bureau/ville/\(place)"
        }
        
        guard let _url = URL.init(string: urlString) else { return }
        
        var _urlRequest: URLRequest = URLRequest.init(url: _url)
        _urlRequest.httpMethod = HTTPMethod.get.rawValue
        
        let headers :[String: String?] = [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        _urlRequest.allHTTPHeaderFields = headers as? [String : String]
        
        Alamofire.request(_urlRequest).responseJSON { (response) in
            switch response.result {
            case .success( _):
                do {
                    if let data = response.data {
                        let postOfficesPro = try JSONDecoder().decode(PostOfficesPro.self, from: data)
                        success(postOfficesPro)
                    } else {
                        failure()
                    }
                } catch {
                    failure()
                }
            case .failure:
                failure()
            }
        }
    }
    
    private func isPostalCode(place: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "[(?:[0-8]\\d|9[0-8])\\d{3}]", options: NSRegularExpression.Options.caseInsensitive)
            return regex.firstMatch(in: place, options: [], range: NSRange(location: 0, length: place.utf16.count)) != nil
        } catch {
            return false
        }
    }
    
}
