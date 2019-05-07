//
//  ForgottenPasswordModel.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 26/09/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit
import Alamofire
import Foundation

enum ForgottenError {
    case none
    case email
    case network
}

class ForgottenPasswordError: Codable {
    var errors: [ForgottenPasswordBodyError]?
}

class ForgottenPasswordBodyError: Codable {
    var codeError: String?
    var message: String?
    var type: String?
}

class ForgottenPasswordModel {

    func resetPassword(email: String, completion: @escaping ((ForgottenError) -> Void)) {
        
        let headers :[String: String?] = [
            "Content-Type": "application/json"
        ]
        
        let urlString = "https://" + EnvironmentUrlsManager.sharedManager.getHybrisServiceHost() + "/eboutiquecommercewebservices/v2/eboutiquePro/resetPassword?email=" + email
        
        let url = URL(string: urlString)
        guard let _url = url else {
            return
        }
        
        var request = URLRequest(url: _url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.allHTTPHeaderFields = headers as? [String : String]
        
        Alamofire.request(request).responseJSON { response in
            switch response.result {
            case .success( _):
                let forgottenPasswordResponse = try! JSONDecoder().decode(ForgottenPasswordError.self, from: response.data!)
                if let codeError = forgottenPasswordResponse.errors?.first?.codeError {
                    if codeError == "INVALID_EMAIL" {
                        completion(.email)
                    } else {
                        completion(.network)
                    }
                } else {
                    completion(.none)
                }
            case .failure:
                if response.result.error?.localizedDescription == "Response could not be serialized, input data was nil or zero length." {
                    completion(.none)
                } else {
                    completion(.network)
                }
            }
        }
    }
}
