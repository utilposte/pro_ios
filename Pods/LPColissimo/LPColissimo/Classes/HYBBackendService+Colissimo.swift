//
//  HYBBackendService+Colissimo.swift
//  LPColissimo
//
//  Created by SPASOV DIMITROV Vladimir on 5/11/18.
//

import Foundation
import LPSharedMCM


extension HYBBackendService {

    func urlAddToCartColissimo(guidCart:String) -> String {
        return self.restPrefix() + "/users/" + userId + "/carts/current/addColissimoToCart?fields=FULL"
    }
    
    func urlGetFavorisColissimo() -> String {
        return self.restPrefix() + "/ColissimoWs/users/" + userId + "/getWishlist"
    }
    
    func urlAddFavorisColissimo() -> String {
        return self.restPrefix() + "/ColissimoWs/users/" + userId + "/wishlist"
    }
    
    func urlDeleteFavorisColissimo(favorisId: String) -> String {
        return self.restPrefix() + "/ColissimoWs/users/" + userId + "/removeFromWishlist?favorisId=" + favorisId
    }
    
    func urlGetBordereauxAffranchissmentColissimo(orderCode: String) -> String {
        return self.restPrefix() + "/ColissimoWs/users/" + userId + "/getBordereauxAffranchissement?orderCode=" + orderCode
    }
    
//    func urlGetOreders(orderCode: String?) -> String {
//        return self.restPrefix() + "/ColissimoWs/users/" + userId + "/orders/" + orderCode
//    }

}
