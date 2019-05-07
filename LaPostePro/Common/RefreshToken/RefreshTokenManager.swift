//
//  RefreshTokenManager.swift
//  LaPostePro
//
//  Created by Issam DAHECH on 12/11/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import Foundation
import LPSharedMCM

class RefreshTokenManager {
    static let shared = RefreshTokenManager()
    
    private func backendService() -> HYBB2CService  {
        let wrapper = HYBB2CServiceWrapper.sharedInstance() as! HYBB2CServiceWrapper
        return wrapper.backEndService
    }
    
    func appDidRefreshToken(refreshToken : String, callback:@escaping (Bool) -> ()) {
        self.refreshToken(token: refreshToken) { (accessToken, error) in
            if let _accessToken = accessToken {
                saveToken(token: _accessToken)
                self.getUserInfo(callback: { (customerInfo, error) in
                    if let _customerInfo = customerInfo {
                        UserAccount.shared.customerInfo = _customerInfo
                        ConnectionViewModel.setMCMUserCredential(email: _customerInfo.displayUid ?? "", accessToken: _accessToken.accessToken ?? "", expiresIn:  "\(_accessToken.expiresIn ?? 0)", refreshToken: _accessToken.refreshToken ?? "", tokenType: _accessToken.tokenType ?? "")
                        callback(true)
                    }
                    else {
                        callback(false)
                    }
                })
            }
            else {
                callback(false)
            }
        }
    }
    
    func refreshToken(token : String, callback:@escaping (AccessTocken?, LPNetworkError?) -> ()){
        let lpError = (MCMNetworkManager.sharedManager() as! MCMNetworkManager).prepareNetworkRequest()
        if(lpError == nil) {
            self.backendService().refershToken(token :token, callback: callback)
        }
        else {
            callback(nil, lpError)
        }
    }
    
    func getUserInfo(callback:@escaping (CustomerInfo?, LPNetworkError?) -> ()) {
        let lpError = (MCMNetworkManager.sharedManager() as! MCMNetworkManager).prepareNetworkRequest()
        if(lpError == nil) {
            self.backendService().getUserInfo(callback: callback)
        }
        else {
            callback(nil, lpError)
        }
    }
    
}

func saveToken(token : AccessTocken) {
    UserAccount.shared.accessToken = token.accessToken
    let keychainService = KeychainService()
    keychainService.saveTokens(accessToken: token.accessToken ?? "", expiresIn: "\(token.expiresIn ?? 0)", refreshToken: token.refreshToken ?? "", tokenType: token.tokenType ?? "")
}
