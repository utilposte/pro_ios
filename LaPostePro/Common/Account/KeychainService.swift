//
//  KeychainService.swift
//  LaPostePro
//
//  Created by Lassad Tiss on 03/07/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import KeychainSwift

enum TokenState : Int {
    case notExist = 0
    case valid = 1
    case expired = 2
    
}

class KeychainService {

    let emailkey = "email"
    let passwordkey = "password"
    let accessTokenkey = "accessToken"
    let expiresInkey = "expiresIn"
    let refreshTokenkey = "refreshToken"
    let tokenTypekey = "tokenType"

    
    // MARK: Properties
    let keychain = KeychainSwift()
    
    // MARK: - User Credentials
    func saveUserCredentials(email: String, password: String) {
        keychain.set(email, forKey: emailkey)
        keychain.set(password, forKey: passwordkey)
    }
    
    func deleteUserCredentials() {
        keychain.delete(emailkey)
        keychain.delete(passwordkey)
    }
    
    // MARK: - Access Token
    func saveTokens(accessToken: String, expiresIn: String, refreshToken: String, tokenType: String) {
        keychain.set(accessToken, forKey: accessTokenkey)
        let timeStamp = Int(Date().timeIntervalSince1970) + Int(expiresIn)!
        keychain.set("\(timeStamp)", forKey: expiresInkey)
        keychain.set(refreshToken, forKey: refreshTokenkey)
        keychain.set(tokenType, forKey: tokenTypekey)
    }
    
    func deleteTokens() {
        keychain.delete(accessTokenkey)
        keychain.delete(expiresInkey)
        keychain.delete(refreshTokenkey)
        keychain.delete(tokenTypekey)        
    }
    
    func get(key: String) -> String? {
        return keychain.get(key)
    }
    
    func isValidToken() -> TokenState {
        if get(key: accessTokenkey) != nil,  get(key: expiresInkey) != nil{
            let expiresIn = get(key: expiresInkey)
            let timeStamp = Int(expiresIn!)
            let currentTimeStamp = Int(Date().timeIntervalSince1970)
            if timeStamp! > currentTimeStamp {
                return .valid
            }
            else {
                return .expired
            }
        }
        else {
            return .notExist
        }
    }
}
