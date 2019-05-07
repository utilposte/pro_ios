//
//  ConnectionViewModel.swift
//  LaPostePro
//
//  Created by Lassad Tiss on 02/07/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import Alamofire
import LPSharedMCM
import SwiftyJSON

class ConnectionViewModel {
    let keychainService = KeychainService()
    
    class func setMCMUserCredential(email:String, accessToken: String, expiresIn: String, refreshToken: String, tokenType:String) {
        let dictTokenData : NSMutableDictionary = NSMutableDictionary()
        dictTokenData["access_token"] = accessToken
        dictTokenData["expiresIn"] = expiresIn
        dictTokenData["refresh_token"] = refreshToken
        dictTokenData["token_type"] = tokenType
        
        let dict : NSMutableDictionary = NSMutableDictionary()
        dict["MCMUser_Complete_Access_Token_Key"] = dictTokenData
        dict["email"] = email
        
        MCMManager.sharedInstance().setUserCredentials(dict as? [AnyHashable : Any])
    }
    
    func initData(onCompletion: @escaping (Bool) -> Void) {
        InitialNetworkingManager().initData() { (success) in
            onCompletion(success)
        }
    }
    
    func connect(with email: String, password: String, onCompletion: @escaping (ConnectionReturnType) -> Void) {
//        onCompletion(true)
        AccountNetworkManager().connect(with: email, password: password) { (isConnected, accessToken, expiresIn, refreshToken, tokenType) in
            if isConnected  == .connected{
                if (accessToken == nil || expiresIn == nil || refreshToken == nil || tokenType == nil ) {
                    onCompletion(.internalError)
                    return
                }
                self.keychainService.saveUserCredentials(email: email, password: password)
                self.keychainService.saveTokens(accessToken: accessToken!, expiresIn: "\(expiresIn!)", refreshToken: refreshToken!, tokenType: tokenType!)
                ConnectionViewModel.setMCMUserCredential(email: email, accessToken: accessToken!, expiresIn: "\(expiresIn!)", refreshToken: refreshToken!, tokenType: tokenType!)
                onCompletion(.connected)
            } else {
                onCompletion(isConnected)
            }
        }
    }
}
