//
//  HYBOrderEntry+Extension.swift
//  LaPostePro
//
//  Created by Matthieu Lemonnier on 09/01/2019.
//  Copyright © 2019 App Mobile. All rights reserved.
//

import Foundation
import LPSharedMCM

extension HYBOrderEntry {
    
    func isColissimo() -> Bool {
        return self.identifier.uppercased().contains("COLIS_") && self.productType == Constants.colissimoProductType
    }
    
    func isAttachementColissimo() -> Bool {
        return self.identifier.uppercased().contains("COLIS_") && self.productType != Constants.colissimoProductType
    }
    
    func isREEX() -> Bool {
            return (self.product.code.contains("TN")
                || self.product.code.contains("TI")
                || self.product.code.contains("DN")
                || self.product.code.contains("DI")) && self.options != nil
    }
    
    func isService() -> Bool {
        return !(self.productType == "PH")
        //return self.isColissimo() || self.isAttachementColissimo() || self.isREEX()
    }    
}

