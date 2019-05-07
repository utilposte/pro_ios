//
//  HYBB2CService+Extension.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 23/07/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit
import LPSharedMCM

extension HYBB2CService {
    
    func getDeliveryModeRequest(callback:@escaping (Any?, LPNetworkError?) -> ()) {
        let url = getDeliveryModeURL()
        
        restEngine.get(url, success: { (operation, responseObject) in
            callback(responseObject, nil)
        }, failure: { operation, error in
            callback(nil, LPNetworkError(error: error))
        })
    }
    
    // MARK: - ACCOUNT
    func refershToken(token : String, callback:@escaping (AccessTocken?, LPNetworkError?) -> ()) {
        let url = urlRefreshToken()

        let myParams = "refresh_token=\(token)"
        let postData = myParams.data(using: String.Encoding.ascii, allowLossyConversion: true)
        let postLength = String(format: "%d", postData?.count ?? 0)
        
        let myRequest = NSMutableURLRequest(url: URL(string: url)!)
        myRequest.httpMethod = "POST"
        myRequest.setValue(postLength, forHTTPHeaderField: "Content-Length")
        myRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        myRequest.httpBody = postData
        
        
        restEngine.url(url, request: myRequest, success: { (operation, responseObject) in
            do {
                let dataJson = try JSONSerialization.data(withJSONObject: responseObject as Any, options: JSONSerialization.WritingOptions.prettyPrinted)
                let accessToken = try? JSONDecoder().decode(AccessTocken.self, from: dataJson)
                callback(accessToken, nil)
            } catch {
                Logger.shared.debug(error.localizedDescription)
                callback(nil, LPNetworkError(error: error))
            }
        }) { (operation, error) in
            callback(nil, LPNetworkError(error: error))
        }
    }
    
    func getUserInfo(callback:@escaping (CustomerInfo?, LPNetworkError?) -> ()) {
        let url = urlUserInfo()
        restEngine.get(url, success: { (operation, responseObject) in
            do {
                let dataJson = try JSONSerialization.data(withJSONObject: responseObject as Any, options: JSONSerialization.WritingOptions.prettyPrinted)
                let customerInfo = try? JSONDecoder().decode(CustomerInfo.self, from: dataJson)
                callback(customerInfo, nil)
            } catch {
                Logger.shared.debug(error.localizedDescription)
                callback(nil, LPNetworkError(error: error))
            }
        }) { (operation, error) in
            callback(nil, LPNetworkError(error: error))
        }
    }
    
    func getClaimReasonFor(_ productId : String, isClaim : Bool, callback:@escaping (ReturnProductReasons?, LPNetworkError?) -> ()) {
        let url = urlScoreClaimReason()
        let requestType = isClaim ? "Claim" : "Return"

        let params = ["requestType":requestType,"idProduct":productId]
        
        restEngine.get(url, withParams: params, success: { (operation, responseObject) in
            do {
                let dataJson = try JSONSerialization.data(withJSONObject: responseObject as Any, options: JSONSerialization.WritingOptions.prettyPrinted)
                let customerInfo = try? JSONDecoder().decode(ReturnProductReasons.self, from: dataJson)
                callback(customerInfo, nil)
            } catch {
                Logger.shared.debug(error.localizedDescription)
                callback(nil, LPNetworkError(error: error))
            }
            }) { (operation, error) in
                callback(nil, LPNetworkError(error: error))
            }
    }
    
    func postClaim(product : ReturnOrderModel, callback:@escaping (Bool) -> ()) {
        guard let params = try? product.asDictionary() else {
            callback(false)
            return
        }
        let url = urlScoreClaim()
        if let jsonData = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted) {
            let jsonString = String(data: jsonData, encoding: String.Encoding.utf8)
            var request = try? URLRequest(url: url, method: .post)
            Logger.shared.info(jsonString)
            request?.httpBody = jsonString?.data(using: .utf8)
            request?.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request?.setValue("application/json", forHTTPHeaderField: "Accept")
            
            restEngine.url(url, request: request as? NSMutableURLRequest, success: { (operation, responseObject) in
                do {
                    callback(true)
                }
            }, failure: { operation, error in
                callback(false)
            })
        } else {
            callback(false)
        }
    }
}
