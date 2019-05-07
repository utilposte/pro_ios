//
//  ColissimoAPIClient+Hybris.swift
//  LPColissimo
//
//  Created by SPASOV DIMITROV Vladimir on 6/11/18.
//

import LPSharedMCM


extension ColissimoAPIClient {
    
    func backendService() -> HYBB2CService  {
        let wrapper = HYBB2CServiceWrapper.sharedInstance() as! HYBB2CServiceWrapper
        return wrapper.backEndService
    }

    
    public func getUserCart(user: String, fields: String, callback :@escaping (HYBCart?, LPNetworkError?) -> ()) {
        
        let lpError = (MCMNetworkManager.sharedManager() as! MCMNetworkManager).prepareNetworkRequest()
        if(lpError == nil) {
            backendService().getCartForUserId(user, andCartId: CURRENT_CART) { (result, error) in
                if let cart = result as? HYBCart {
                    HYBCache.cacheObject(cart, forKey: CURRENT_CART_KEY)
                    callback(cart, nil)
                }
                else if (error != nil) {
                    print("getUserCart error")
                    callback(nil, LPNetworkError(error: error))
                }
            }
        }
        else {
            print(lpError!.error)
            callback(nil, lpError)
        }
        
    }
    
    public func addToCart(user: String, fields: String, parameters: [String: Any], callback :@escaping (HYBCart?, LPNetworkError?) -> ()) {
        
        let lpError = (MCMNetworkManager.sharedManager() as! MCMNetworkManager).prepareNetworkRequest()
        if(lpError == nil) {
            backendService().addToCartColissimo(params: parameters) { (result, error) in
                if let cart = result {
                    // TODO: Do we cache the object?
                    HYBCache.cacheObject(cart, forKey: CURRENT_CART_KEY)
                    callback(cart, nil)
                } else if (error != nil) {
                    print("addToCart error")
                    callback(nil, error)
                }
            }
        }
        else {
            print(lpError!.error)
            callback(nil, lpError)
        }
    }
    
    public func getFavoris(user: String, callback :@escaping (HYBColissimoList?, LPNetworkError?) -> ()) {
        let lpError = (MCMNetworkManager.sharedManager() as! MCMNetworkManager).prepareNetworkRequest()
        if(lpError == nil) {
            backendService().getFavoris(user: user) { (result, error) in
                if let favoris = result {
                    callback(favoris, nil)
                } else if (error != nil) {
                    print("getFavoris error")
                    callback(nil, error)
                }
            }
        }
        else {
            print(lpError!.error)
            callback(nil, lpError)
        }
    }
    
    public func addToFavoris(user: String, parameters: [String: Any], callback :@escaping (LPNetworkError?) -> ()) {
        let lpError = (MCMNetworkManager.sharedManager() as! MCMNetworkManager).prepareNetworkRequest()
        if(lpError == nil) {
            backendService().addToFavoris(params:parameters ,user: user) { (error) in
                if (error != nil) {
                    print("addToFavoris error")
                    callback(error)
                }
            }
        }
        else {
            print(lpError!.error)
            callback(lpError)
        }
    }
    
    public func deleteFavoris(user: String, favorisId: String, callback :@escaping (LPNetworkError?) -> ()) {
        let lpError = (MCMNetworkManager.sharedManager() as! MCMNetworkManager).prepareNetworkRequest()
        if(lpError == nil) {
            backendService().deleteFavoris(favorisId:favorisId ,user: user) { (error) in
                if (error != nil) {
                    print("deleteFavoris error")
                    callback(error)
                }
            }
        }
        else {
            print(lpError!.error)
            callback(lpError)
        }
    }
    
    public func getOrders(user: String, callback :@escaping ([HYBOrderHistory]?, LPNetworkError?) -> ()) {
        let lpError = (MCMNetworkManager.sharedManager() as! MCMNetworkManager).prepareNetworkRequest()
        if(lpError == nil) {
            backendService().getOrdersForUserId(user, withParams: nil) { (result, error) in
                if (error == nil) {
                    guard let orders = (result as? [HYBOrderHistory]) else {
                        return
                    }
                    callback(orders, nil)
                } else {
                   callback(nil, LPNetworkError(error: error))
                }
            }
        }
        else {
            print(lpError!.error)
            callback(nil, lpError)
        }
    }
    
    public func getOrdersDetails(user: String, orderCode: String?, callback :@escaping (HYBOrder?, LPNetworkError?) -> ()) {
        let lpError = (MCMNetworkManager.sharedManager() as! MCMNetworkManager).prepareNetworkRequest()
        if(lpError == nil) {
            backendService().findOrder(byCode: orderCode) { (result, error) in
                if (error == nil) {
                    guard let orders = (result as? HYBOrder) else {
                        return
                    }
                    callback(orders, nil)
                } else {
                    callback(nil, LPNetworkError(error: error))
                }
            }
        }
        else {
            print(lpError!.error)
            callback(nil, lpError)
        }
    }
    
    public func getBordereauxAffranchissement(user: String, orderCode: String, callback:@escaping (Data?, LPNetworkError?)->()) {
        backendService().getBordereauxAffranchissment(orderCode: orderCode, user: user) { (result, error) in
            if (error != nil) {
                print("getBordereauxAffranchissement error")
                callback(nil, error)
            } else {
                callback(result, nil)
            }
        }
    }

}
