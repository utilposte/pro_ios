//
//  AccountNetworkManager.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 05/07/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift
import SwiftyJSON
import LPSharedMCM

enum ConnectionReturnType : Int {
    case connected
    case credentials
    case internalError
    case noNetwork
    
    var message : String {
        switch self {
        case .credentials:
            return "L'identifiant et/ou le mot de passe saisi sont incorrects."
        case .internalError:
            return "Serveur indisponible. Merci de réessayer."
        case .noNetwork:
            return "Vous n'êtes plus connecté à Internet"
        default:
            return ""
        }
    }
}

class ConnectionBody: Codable {
    var email: String?
    var password: String?
}


class AccountNetworkManager {
    
    let hybServiceWrapper = (HYBB2CServiceWrapper.sharedInstance() as! HYBB2CServiceWrapper)
    
    func connect(with email: String, password: String, onCompletion: @escaping (ConnectionReturnType, String?, Int?, String?, String?) -> Void) {
        
        if isConnectedToInternet() == false {
            onCompletion(.noNetwork, nil, nil, nil, nil)
            return
        }
        
        // Add Headers
        let headers = [
            "Accept": "application/json",
            "Content-Type": "application/json",
            ]
        
        let url = "https://" + EnvironmentUrlsManager.sharedManager.getHybrisServiceHost() + "/eboutiquecommercewebservices/v2/eboutiquePro" + "/authenticate"
        
        let connection = ConnectionBody()
        connection.email = email
        connection.password = password
        
        let encoder = JSONEncoder()
        let jsonData = try! encoder.encode(connection)
        
        // Fetch Request
        
        if let _url = URL.init(string: url) {
            var urlRequest = URLRequest.init(url: _url)
            urlRequest.httpMethod = HTTPMethod.post.rawValue
            urlRequest.httpBody = jsonData
            urlRequest.allHTTPHeaderFields = headers
            
            Alamofire.request(urlRequest)
                .validate(statusCode: 200..<300)
                .responseJSON { response in
                    var errorResult : ConnectionReturnType = .internalError
                    if response.response?.statusCode == 503 {
                        errorResult = .credentials
                    }
                    if (response.result.error == nil) {
                        do {
                            let connectionResponse = try JSONDecoder().decode(ConnectionResponse.self, from: response.data!)
                            if let accessToken  = connectionResponse.accessToken {
                                UserAccount.shared.accessToken = accessToken.accessToken
                                UserAccount.shared.customerInfo = connectionResponse.customerInfo
                                onCompletion(.connected, accessToken.accessToken, accessToken.expiresIn, accessToken.refreshToken, accessToken.tokenType)
                            }
                            
                        } catch {
                            onCompletion(errorResult, nil, nil, nil, nil)
                        }
                    }
                    else {
                        onCompletion(errorResult, nil, nil, nil, nil)
                    }
            }
        } else {
            onCompletion(.internalError, nil, nil, nil, nil)
        }
    }
    
    
    func generateSignature(dataForm: UpdateFormModel) -> (signature: String, time: String)? {
        if let email = dataForm.email {
            let date = Date()
            let calendar = Calendar.current
            
            let year = calendar.component(.year, from: date)
            let month = calendar.component(.month, from: date)
            let day = calendar.component(.day, from: date)
            
            let time = String(format: "%02d", day) + String(format: "%02d", month) + String(format: "%04d", year)
            let k0 = "HYB_2018"
            
            if  let firstName = dataForm.firstName ,
                let lastName = dataForm.lastName,
                let companyTypeCode = dataForm.companyTypeCode,
                let titleCode = dataForm.titleCode,
                let countryCode = dataForm.countryCode,
                let locality = dataForm.localite,
                let companyName = dataForm.companyName,
                let postalCode = dataForm.codePostal,
                let k1 = (email + time + k0).md5(),
                let password = dataForm.pwd
            {
                if let prefixLastName = lastName.first {
                    let last3password = String(password.suffix(3))
                    var signature : String = (email + firstName + String(prefixLastName))                    
                    signature += (companyTypeCode + last3password + titleCode)
                    signature += (countryCode + locality + companyName + postalCode + k1)
                    if let sha256 = signature.sha256() {
                        return (signature: sha256, time: time)
                    }
                    return nil
                }
                //sha256 (Email + firstName + premier caractère lastName + companyTypeCode + 3 dernier caracteres pwd + titleCode + countryCode + localite + companyName + codePostal + key1)
            }
        }
        return nil
    }
    
    func initInscription(acceptError : Bool = false, dataForm:UpdateFormModel , onCompletion: @escaping ([AccountNetworkError]?, String?, Int?, String?, String?) -> Void) {
        
        var newDataForm = dataForm
        newDataForm.countryCode = newDataForm.countryCode?.lowercased()
        let dataSignature = self.generateSignature(dataForm: newDataForm)
        newDataForm.checkPwd = newDataForm.pwd
        newDataForm.checkEmail = newDataForm.email
        newDataForm.time = dataSignature?.time
        newDataForm.signature = dataSignature?.signature
        newDataForm.acceptConditions = true
        
        var canAcceprtError = ""
        if acceptError == true {
            canAcceprtError = "?acceptError=true"
        }
        let urlString = "https://" + EnvironmentUrlsManager.sharedManager.getHybrisServiceHost() + "/eboutiquecommercewebservices/v2/eboutiquePro" + "/registerNewProUser" + canAcceprtError
        
        let headers :[String: String?] = [
            "Content-Type" : "application/json",
            "Accept": "application/json",
            ]
        
        let body = try! JSONEncoder().encode(newDataForm)
        
        let url = URL(string: urlString)
        guard let _url = url else {
            return
        }
        
        var request = URLRequest(url: _url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.allHTTPHeaderFields = headers as? [String : String]
        request.httpBody = body
        
        Alamofire.request(request).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                if let responseObject = value as? [String : Any] {
                    if (responseObject["errors"] as? [[String : Any]]) != nil {
                        do {
                            if let data = response.data {
                                let error = try JSONDecoder().decode(ErrorWS.self, from: data)
                                let errors = AccountNetworkErrorManager().getListOfErrorsfrom(error)
                                onCompletion(errors, nil, nil, nil, nil)
                            }
                            else {
                                onCompletion([AccountNetworkError()], nil, nil, nil, nil)
                            }
                        }
                        catch {
                            onCompletion([AccountNetworkError()], nil, nil, nil, nil)
                        }
                    }
                    else {
                        do {
                            let connectionResponse = try JSONDecoder().decode(ConnectionResponse.self, from: response.data!)
                            if let accessToken  = connectionResponse.accessToken {
                                UserAccount.shared.accessToken = accessToken.accessToken
                                UserAccount.shared.customerInfo = connectionResponse.customerInfo
                                onCompletion(nil, accessToken.accessToken, accessToken.expiresIn, accessToken.refreshToken, accessToken.tokenType)
                                break
                            }
                        } catch {
                            onCompletion([AccountNetworkError()], nil, nil, nil, nil)
                            break
                        }
                    }
                } else {
                    onCompletion([AccountNetworkError()], nil, nil, nil, nil)
                    break
                }
            case .failure(_):
                onCompletion([AccountNetworkError()], nil, nil, nil, nil)
                break
            }
        }
    }
    
    func updateEmail(emailModel: EmailModel, onCompletion: @escaping (Bool) -> Void) {
        // CREATE HTTP HEADER
        let keychainService = KeychainService()
        let authorization = String(format: "Bearer %@", keychainService.get(key: keychainService.accessTokenkey) ?? "")
        
        let headers :[String: String?] = [
            "Authorization": authorization,
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        let urlString = "https://" + EnvironmentUrlsManager.sharedManager.getHybrisServiceHost() + "/eboutiquecommercewebservices/v2/eboutiquePro/users/"
        guard let email = UserAccount.shared.customerInfo?.displayUid, let newLogin = emailModel.newLogin, let password = emailModel.password else { return }
        let urlString2 = urlString + email + Constants.updateEmail + "?newLogin=\(newLogin)&password=\(password)"
        
        let url = URL(string: urlString2)
        guard let _url = url else {
            return
        }
        
        var request = URLRequest(url: _url)
        request.httpMethod = HTTPMethod.put.rawValue
        request.allHTTPHeaderFields = headers as? [String : String]
        
        Alamofire.request(request)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let responseObject = value as? [String : Any] {
                        if let error = responseObject["errors"] as? [[String : Any]] {
                            onCompletion(false)
                        } else {
                            do {
                                
                                let userAccountResponse = try JSONDecoder().decode(TokenResponse.self, from: response.data!)
                                if let accessToken  = userAccountResponse.accessToken {
                                    let keychainService = KeychainService()
                                    keychainService.saveTokens(accessToken: accessToken, expiresIn: String(describing: userAccountResponse.expiresIn ?? 0), refreshToken: userAccountResponse.refreshToken ?? "", tokenType: userAccountResponse.tokenType ?? "")
                                    UserAccount.shared.accessToken = userAccountResponse.accessToken
                                    UserAccount.shared.customerInfo?.displayUid = newLogin
                                    onCompletion(true)
                                    break
                                }
                            } catch {
                                onCompletion(false)
                                break
                            }
                        }
                        onCompletion(false)
                        break
                    } else {
                        onCompletion(false)
                        break
                    }
                case .failure:
                    switch response.response!.statusCode {
                    case 200..<300:
                        onCompletion(true)
                    default:
                        onCompletion(false)
                    }
                }
        }
    }
    
    func updatePassword(passwordModel: PasswordModel, onCompletion: @escaping (Bool) -> Void) {
        // CREATE HTTP HEADER
        let keychainService = KeychainService()
        let authorization = String(format: "Bearer %@", keychainService.get(key: keychainService.accessTokenkey) ?? "")
        
        let headers :[String: String?] = [
            "Authorization": authorization,
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        // CREATE BODY
        let body = try! JSONEncoder().encode(passwordModel)
        
        let urlString = "https://" + EnvironmentUrlsManager.sharedManager.getHybrisServiceHost() + "/eboutiquecommercewebservices/v2/eboutiquePro/users/"
        guard let email = UserAccount.shared.customerInfo?.displayUid else { return }
        let urlString2 = urlString + email + Constants.updatePassword
        
        let url = URL(string: urlString2)
        guard let _url = url else {
            return
        }
        
        var request = URLRequest(url: _url)
        request.httpMethod = HTTPMethod.put.rawValue
        request.allHTTPHeaderFields = headers as? [String : String]
        request.httpBody = body
        
        Alamofire.request(request)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let responseObject = value as? [String : Any] {
                        if let error = responseObject["errors"] as? [[String : Any]] {
                            onCompletion(false)
                        }
                        else {
                            do {
                                do {
                                    let userAccountResponse = try JSONDecoder().decode(ConnectionResponse.self, from: response.data!)
                                    if let accessToken  = userAccountResponse.accessToken {
                                        UserAccount.shared.accessToken = accessToken.accessToken
                                        UserAccount.shared.customerInfo = userAccountResponse.customerInfo
                                        onCompletion(true)
                                        break
                                    }
                                } catch {
                                    onCompletion(false)
                                }
                                
                                let userAccountResponse = try JSONDecoder().decode(ConnectionResponse.self, from: response.data!)
                                if let accessToken  = userAccountResponse.accessToken {
                                    UserAccount.shared.accessToken = accessToken.accessToken
                                    UserAccount.shared.customerInfo = userAccountResponse.customerInfo
                                    onCompletion(true)
                                    break
                                }
                            } catch {
                                onCompletion(false)
                                break
                            }
                        }
                        onCompletion(false)
                        break
                    } else {
                        onCompletion(false)
                        break
                    }
                case .failure:
                    switch response.response!.statusCode {
                    case 200..<300:
                        onCompletion(true)
                    default:
                        onCompletion(false)
                    }
                }
        }
    }
    
    func updateCompanyInfo(acceptError : Bool = false, userInfo: UpdateFormModel, onCompletion: @escaping ([AccountNetworkError]?) -> Void) {
        let keychainService = KeychainService()
        let authorization = String(format: "Bearer %@", keychainService.get(key: keychainService.accessTokenkey) ?? "")
        
        let headers :[String: String?] = [
            "Authorization": authorization,
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        // Fetch Request
        let body = try! JSONEncoder().encode(userInfo)
        
        var canAcceprtError = ""
        if acceptError == true {
            canAcceprtError = "?acceptError=true"
        }
        
        let urlString = "https://" + EnvironmentUrlsManager.sharedManager.getHybrisServiceHost() + "/eboutiquecommercewebservices/v2/eboutiquePro/users/"
        guard let email = UserAccount.shared.customerInfo?.displayUid else { return }
        let urlString2 = urlString + email + Constants.updateProUser + canAcceprtError
        
        let url = URL(string: urlString2)
        guard let _url = url else {
            return
        }
        
        var request = URLRequest(url: _url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.allHTTPHeaderFields = headers as? [String : String]
        request.httpBody = body
        
        Alamofire.request(request)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let responseObject = value as? [String : Any] {
                        if responseObject["errors"] != nil {
                            // getErrors
                            do {
                                if let data = response.data {
                                    let error = try JSONDecoder().decode(ErrorWS.self, from: data)
                                    let errors = AccountNetworkErrorManager().getListOfErrorsfrom(error)
                                    onCompletion(errors)
                                }
                                else {
                                    onCompletion([AccountNetworkError()])
                                }
                            }
                            catch {
                                onCompletion([AccountNetworkError()])
                            }
                        }
                        else {
                            do {
                                let userAccountResponse = try JSONDecoder().decode(ConnectionResponse.self, from: response.data!)
                                UserAccount.shared.customerInfo = userAccountResponse.customerInfo
                                onCompletion(nil)
                            }
                            catch {
                                onCompletion([AccountNetworkError()])
                            }
                        }
                    }
                case .failure:
                    onCompletion([AccountNetworkError()])
                }
        }
    }
    
    private func createUrlForInit() -> String {
        let url = String(format: "%@%@/%@%@", "https://", EnvironmentUrlsManager.sharedManager.getHybrisServiceHost(), createWSSuffix() ,Constants.initDataForInscriptionUrl)
        return url
    }
    
    private func createWSSuffix() -> String {
        var wsSuffix = ""
        var myDict: NSDictionary?
        if let path = Bundle.main.path(forResource: Constants.EnvironmentsHybrisPlistFileName, ofType: "plist") {
            myDict = NSDictionary(contentsOfFile: path)
        }
        if let dict = myDict {
            let defaultDictionary = dict[Constants.DefaultPlistDictionary] as! [String : String]
            wsSuffix = String(format: "%@/%@", defaultDictionary[Constants.webServiceKeyForConfiguration]!, defaultDictionary[Constants.boutiqueTypeKeyForConfiguration]!)
        }
        return wsSuffix
    }
    
    func checkChorus(with siret: String, onCompletion: @escaping (Bool, [Service]?) -> Void){
        
        let headers = [
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded",
            ]
        
        let url = "https://" + EnvironmentUrlsManager.sharedManager.getHybrisServiceHost() + "/eboutiquecommercewebservices/v2/eboutiquePro" + "/chorusServicesCodes?siret=" + siret
        // Fetch Request
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                if (response.result.error == nil) {
                    do {
                        let response = try JSONDecoder().decode(CheckChorusResponse.self, from: response.data!)
                        onCompletion(response.isChorusPartner, response.serviceList)
                    } catch {
                        onCompletion(false, nil)
                    }
                }
                else {
                    onCompletion(false, nil)
                }
        }
    }
    
    func mascadiaVerification(for address: [String: String], onCompletion: @escaping (NSDictionary) -> Void){
        var params = ["idClient": "LPFR",
                      "passwdClient":"4SJDaSQv1n",
                      "typeResultat":"json"]
        let url = "https://www.serca.laposte.fr/services/mascadia/controleAdresse"
        params.merge(address, uniquingKeysWith: { (first, _) in first })
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
            .responseJSON { response in
                if (response.result.error == nil) {
                    guard let json = response.result.value as?  NSDictionary else {
                        return
                    }
                    let retourResponse = json["retour"] as! NSDictionary
                    onCompletion(retourResponse)
                }
                else {
                    onCompletion([:])
                }
        }
    }
    
    func checkEmailBeforeInscription(email: String, onCompletion: @escaping (Bool) -> Void) {
        let url = "https://" + EnvironmentUrlsManager.sharedManager.getHybrisServiceHost() + "/eboutiquecommercewebservices/v2/eboutiquePro" + "/checkNotExistEmail?email=" + email
        Alamofire.request(url, method: .post, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .responseJSON { response in
                if (response.result.error == nil) {
                    guard let json = response.result.value as?  NSDictionary else {
                        onCompletion(false)
                        return
                    }
                    if json["errors"] != nil {
                        onCompletion(true)
                    } else {
                        onCompletion(false)
                    }
                }
                else {
                    onCompletion(false)
                }
        }
    }
    
    func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

class TokenResponse: Codable {
    var accessToken: String?
    var expiresIn: Int?
    var refreshToken: String?
    var tokenType: String?
}
