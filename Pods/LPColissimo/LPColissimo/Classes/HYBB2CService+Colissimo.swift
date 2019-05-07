//
//  HYBB2CService+Colissimo.swift
//  LPColissimo
//
//  Created by SPASOV DIMITROV Vladimir on 5/11/18.
//

import Foundation
import LPSharedMCM
import Mantle

extension HYBB2CService {
    
    func addToCartColissimo (params: [String:Any], callback:@escaping (HYBCart?, LPNetworkError?) -> ()){
        
        let url = urlAddToCartColissimo(guidCart: guidCart())
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        let jsonString = String(data: jsonData!, encoding: String.Encoding.utf8)
        var request = try? URLRequest(url: url, method: .post)
        
        request?.httpBody = jsonString?.data(using: .utf8)
        request?.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request?.setValue("application/json", forHTTPHeaderField: "Accept")
        
        
        restEngine.url(url, request: request as? NSMutableURLRequest, success: { (operation, responseObject) in
            
            do {
                guard responseObject != nil else {
//                    callback(nil, nil)
                    return
                }
                
                let jsonData = operation!.responseString.data(using: .utf8)
                let dict = try JSONSerialization.jsonObject(with: jsonData!, options:[]) as! [String : Any]
                let cart = try HYBCart.createWith(params: dict["cartWsDTO"] as! [String : Any])
                
                callback(cart, nil)
                

            } catch {
                print( error)
                callback(nil, LPNetworkError(error: error))
            }
        }, failure: { operation, error in
            print(LPNetworkError(error: error)!)
            callback(nil, LPNetworkError(error: error))
            
        })
    }
    
    func getFavoris (user: String, callback:@escaping (HYBColissimoList?, LPNetworkError?) -> ()){
        let url = urlGetFavorisColissimo()
        
        restEngine.get(url, success: { (operation, responseObject) in

            do {
                guard responseObject != nil else {
//                    callback(nil, nil)
                    return
                }
                

                let dict = responseObject as! [String : Any]
                
                let favorits = try MTLJSONAdapter.model(of: HYBColissimoList.self, fromJSONDictionary: dict, error: ()) as! HYBColissimoList
                
                callback(favorits, nil)
                
            } catch {
                print( error)
                callback(nil, LPNetworkError(error: error))
            }
        }, failure: { operation, error in
            print(LPNetworkError(error: error)!)
            callback(nil, LPNetworkError(error: error))
            
        })
    }
    
    
    func addToFavoris (params: [String:Any], user: String, callback:@escaping (LPNetworkError?) -> ()){
        let url = urlAddFavorisColissimo()
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        let jsonString = String(data: jsonData!, encoding: String.Encoding.utf8)
        var request = try? URLRequest(url: url, method: .post)
        
        request?.httpBody = jsonString?.data(using: .utf8)
        request?.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request?.setValue("application/json", forHTTPHeaderField: "Accept")
        
        
        
        
        restEngine.url(url, request: request as? NSMutableURLRequest, success: { (operation, responseObject) in
            callback(nil)
        }, failure: { operation, error in
            print(LPNetworkError(error: error)!)
            callback(LPNetworkError(error: error))
            
        })
    }
    
    func deleteFavoris (favorisId: String, user: String, callback:@escaping (LPNetworkError?) -> ()){
        let url = urlDeleteFavorisColissimo(favorisId: favorisId)
        
        restEngine.delete(url, success: { (operation, responseObject) in
            callback(nil)
        }, failure: { operation, error in
            print(LPNetworkError(error: error)!)
            callback(LPNetworkError(error: error))
            
        })
    }
    
//    func getOrders() {
//        let url = urlGetOreders(orderCode: nil)
//        
//        restEngine.get
//    }
//    
//    func getOrdersDetails(orderCode: String?) {
//        let url = urlGetOreders(orderCode: orderCode)
//    }
    
    func getBordereauxAffranchissment(orderCode: String, user: String, callback:@escaping (Data?, LPNetworkError?) -> ()){
        let url = urlGetBordereauxAffranchissmentColissimo(orderCode: orderCode)
        
        restEngine.getpdf(url, success: { (operation, responseObject) in
            
            guard responseObject != nil else {
                callback(nil, nil)
                return
            }
            
            let nsdata = responseObject as! NSData
            let data = Data(referencing: nsdata)
            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let filePath = "\(documentsPath)/bordereaux.pdf"
            nsdata.write(toFile: filePath, atomically: true)
            callback(data, nil)
                
           
        }, failure: { operation, error in
            print(LPNetworkError(error: error)!)
            callback(nil, LPNetworkError(error: error))
            
        })
    }
    
    func guidCart() -> String {
        if (self.userId == GUEST_USER) {
            if let cart = self.currentCartFromCache() {
                return cart.guid
            }
            else if let guid = UserDefaults.standard.string(forKey: "CURRENT_CART_ANONYMOUS_KEY") {
                return guid
            }
            return ""
        }
        return CURRENT_CART
    }
}
