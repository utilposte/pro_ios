//
//  Date+Format.swift
//  LaPostePro
//
//  Created by Matthieu Lemonnier on 30/08/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import Foundation


extension Date {
    
    static func from(string: String, withFormat: String, identifierLocal: String = "en_US_POSIX") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: identifierLocal)
        dateFormatter.dateFormat = withFormat
        return dateFormatter.date(from: string)
    }
    
    func format(_ format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "FR-fr")
        dateFormatter.dateFormat = format
        return dateFormatter.string(from:self)
    }
    
    func add(days: Int) -> Date {
        let daysInterval = TimeInterval(60*60*24*days)
        return Date(timeInterval: daysInterval, since: self)
    }
    
    static func isAfterTenThirty() -> Bool{
        let calendar = Calendar.current
        let now = Date()
        let tenThitryToday = calendar.date(
            bySettingHour: 10,
            minute: 30,
            second: 0,
            of: now)!
        
        return (now > tenThitryToday)
    }
    
    func adding(hour: Int) -> Date {
        return Calendar.current.date(byAdding: .hour, value: hour, to: self) ?? Date()
    }

    func adding(day: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: day, to: self) ?? Date()
    }
}
