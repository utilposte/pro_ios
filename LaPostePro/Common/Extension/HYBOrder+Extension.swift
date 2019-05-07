//
//  HYBOrder+Extension.swift
//  LaPostePro
//
//  Created by Matthieu Lemonnier on 28/09/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import Foundation
import LPSharedMCM

extension HYBOrderHistory {
    
    func statusDisplayUI() -> String {
        return HYBOrder.mapper(statusDispaly: self.statusDisplay)
    }
    
}

extension HYBOrder {
    
    class func mapper(statusDispaly: String) -> String {
        if statusDispaly.uppercased() == "COMPLETED" {
            return "Complétée"
        }
        return "En cours"
    }
    
    func statusDisplayUI() -> String {
        return HYBOrder.mapper(statusDispaly: self.statusDisplay)
    }
    
    func canReturnOrder() -> Bool{
        
        if self.hasOnlyService() {
            return false
        }
        
        var isValid = false
        if let dateString = self.created {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss+SSSS"
            dateFormatter.locale = Locale.current
            let givenDate: Date = dateFormatter.date(from: dateString) ?? Date()
            if isPassedMoreThan(days: 20, fromDate: givenDate) {
                return false
            }
        }
        // Physical Product ::
        for entry in (self.entries as? [HYBOrderEntry] ?? [HYBOrderEntry]()) {
            if let code = entry.product?.code, code.isNumeric == true { // ( CHECK SIZE OF CODE  || code.count > 7 )
                isValid = true
            }
        }
        return isValid
    
    }
    
    private func isPassedMoreThan(days: Int, fromDate date : Date) -> Bool {
        let unitFlags: Set<Calendar.Component> = [.day]
        let deltaD = Calendar.current.dateComponents( unitFlags, from: date, to: Date())
        return deltaD.day! > days
    }

    func hasOnlyService() -> Bool {
        for entry in (self.entries as! [HYBOrderEntry]) {
            if !entry.isService() {
                return false
            }
        }
        return true
    }
}





private extension String {
    var isNumeric: Bool {
        guard self.count > 0 else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(self).isSubset(of: nums)
    }
}
