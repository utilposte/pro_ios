//
//  OrderNetworkManager.swift
//  LaPostePro
//
//  Created by Issam DAHECH on 23/11/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import Foundation
import LPSharedMCM

class OrderNetworkManager: NSObject {
    
    
    private class func backendService() -> HYBB2CService  {
        let wrapper = HYBB2CServiceWrapper.sharedInstance() as! HYBB2CServiceWrapper
        return wrapper.backEndService
    }
    
    class func getReasonForProduct(productId : String, isClaim : Bool, callback:@escaping (ReturnProductReasons?, LPNetworkError?) -> ()){
        let lpError = (MCMNetworkManager.sharedManager() as! MCMNetworkManager).prepareNetworkRequest()
        if(lpError == nil) {
            OrderNetworkManager.backendService().getClaimReasonFor(productId, isClaim: isClaim, callback: callback)
        }
        else {
            callback(nil, lpError)
        }
    }
    
    class func postClaimForProduct(_ product : ReturnOrderModel, callback:@escaping (Bool) -> ()){
        let lpError = (MCMNetworkManager.sharedManager() as! MCMNetworkManager).prepareNetworkRequest()
        if(lpError == nil) {
            OrderNetworkManager.backendService().postClaim(product: product) { (success) in
                callback(success)
            }
        }
        else {
            callback(false)
        }
    }
    
}
