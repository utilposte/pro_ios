//
//  Double+Decimals.swift
//  LPColissimoUI
//
//  Created by SPASOV DIMITROV Vladimir on 07/02/2019.
//

import Foundation

extension Double {
    var cleanString: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}

extension Float {
    var cleanString: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
