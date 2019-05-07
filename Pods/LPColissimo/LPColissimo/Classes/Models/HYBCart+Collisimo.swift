//
//  HYBCart+Collisimo.swift
//  LPColissimo
//
//  Created by SPASOV DIMITROV Vladimir on 12/11/18.
//

import LPSharedMCM

extension HYBCart {
    
    static func createWith(params: [String : Any]) throws -> HYBCart? {
        
        do {
            let cart = try MTLJSONAdapter.model(of: HYBCart.self, fromJSONDictionary: params, error: ()) as? HYBCart
            return cart
        } catch {
            print("Couldn't convert JSON to model HYBCart");
            return nil;
        }
        
    }
    
}


