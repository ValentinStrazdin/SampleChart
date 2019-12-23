//
//  Date+Formatting.swift
//  SampleChart
//
//  Created by Strazdin, Valentin on 31.10.2019.
//  Copyright © 2019 Strazdin, Valentin. All rights reserved.
//

import Foundation

extension Date {
    
    static func date(from apiString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Strings.apiDateFormat
        dateFormatter.locale = Locale(identifier: Strings.apiDateFormatterLocale)
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.date(from: apiString)
    }

    public func setTime(hour: Int, min: Int, sec: Int) -> Date? {
        let x: Set<Calendar.Component> = [.era, .year, .month, .day, .hour, .minute, .second]
        let cal = Calendar.current
        var components = cal.dateComponents(x, from: self)
        components.hour = hour
        components.minute = min
        components.second = sec
        
        return cal.date(from: components)
    }
    
    /// Here we are calculating day before current date
    var dayBefore: Date? {
        var date = DateComponents()
        date.day = -1
        return Calendar.current.date(byAdding: date, to: self)
    }
}
